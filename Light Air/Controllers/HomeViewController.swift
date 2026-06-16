//
//  ViewController.swift
//  Light Air
//
//  Created by Mihai on 31/01/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var airQualityView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTemperatureLabel: UILabel!
    @IBOutlet weak var cityHumidityLabel: UILabel!
    @IBOutlet weak var temperatureIcon: UIImageView!
    @IBOutlet weak var airQualityLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    private var cityVM: CityViewModel = CityViewModel()
    
    var selectedCity:City?
    var isShowingUserLocation:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserLocationPermissionLevel = UserPermissions.shared.currentUserPermissionStatus {
            UserPermissions.shared.userLocationUsagePreference = currentUserLocationPermissionLevel
        }
        
        locationManager.delegate = self
        self.mapView.delegate = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        ThemeManager.addHeaderImageToNavigationController(sender: self, width: 40, height: 40)
        
        Task {
            await getClosestCityData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let selectedCity = selectedCity {
           self.cityVM = CityViewModel(city: selectedCity)
           self.setupUI()
           self.isShowingUserLocation = false
        }
    }

}

extension HomeViewController {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways) {
            UserPermissions.shared.userLocationUsagePreference = true
            Task {
                await getClosestCityData()
            }
        } else if (status == CLAuthorizationStatus.notDetermined) {
            Task {
                await getClosestCityData()
            }
        } else {
            UserPermissions.shared.userLocationUsagePreference = false
            cityVM.handleServerError(StringsUtils.locationRequestDeniedString, StringsUtils.locationAuthMessageString, StringsUtils.OKString, self)
        }
    }
    
    private func setupUI() {
        self.cityNameLabel.text = cityVM.cityName
        self.cityHumidityLabel.text = cityVM.humidity
        self.cityTemperatureLabel.text = cityVM.temperature
        
        if let pollutionIndex = cityVM.pollutionLevel {
            airQualityView.backgroundColor = cityVM.airQualityBg
            airQualityLabel.text = "\(cityVM.airQuality) // US AQI \(pollutionIndex)"
            airQualityLabel.textColor = cityVM.airQualityFontColor
            airQualityView.alpha = 1
        }
        
        if let iconName = cityVM.iconCode {
            self.temperatureIcon.image = UIImage(named: iconName)
        }
     
        self.navigationItem.title = cityVM.state
        self.detailsView.alpha = 1
        
        if let coordinates = cityVM.location {
            self.zoomInToDesiredLocation(location: coordinates)
        }
    }
    
}

extension HomeViewController {
    
    private func zoomInToDesiredLocation(location: Array<Double>) {
       
        setupCurrentLocationRegion(location: location)
        mapView.removeAnnotations(mapView.annotations)
        
        if let pollutionIndex = cityVM.pollutionLevel {
            let annotation = PollutionAnnotation(pollution: pollutionIndex)
            annotation.coordinate = CLLocationCoordinate2D(latitude: location[1], longitude: location[0])
            annotation.title = annotation.airQuality
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }
    
    private func setupCurrentLocationRegion(location: Array<Double>) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location[1], longitude: location[0]), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          
           var pollutionAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PollutionFlag") as? MKMarkerAnnotationView
           
           if pollutionAnnotationView == nil {
          
                pollutionAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PollutionFlag")
               pollutionAnnotationView?.glyphTintColor = UIColor.white
               pollutionAnnotationView?.canShowCallout = false
               pollutionAnnotationView?.animatesWhenAdded = true
               
            
           } else {
               pollutionAnnotationView?.annotation = annotation
           }
        
            if let annotation = annotation as? PollutionAnnotation {
               if let airQuality = annotation.pollutionIndex  {
                   pollutionAnnotationView?.glyphText = "\(airQuality)"
               }
               pollutionAnnotationView?.markerTintColor = annotation.airQualityColorLabel
           }
           
           return pollutionAnnotationView
           
    }
    
}

extension HomeViewController {

    func getClosestCityData() async {
        locationManager.requestWhenInUseAuthorization()
        if (UserPermissions.shared.userLocationUsagePreference) {
            await initiateServerCallBasedOnUserLocation()
        }
    }
    
    func initiateServerCallBasedOnUserLocation() async {
       if !isShowingUserLocation {
           if let city = await cityVM.getCityData() {
               self.cityVM = CityViewModel(city: city)
               self.setupUI()
               self.selectedCity = nil
               self.isShowingUserLocation = true
               self.cityVM.saveCityData(city)
           } else {
               self.cityVM.handleServerError(StringsUtils.limitReachedString, StringsUtils.pleaseTryAgainString, StringsUtils.OKString, self)
           }
       } else {
           if let currentLocation = cityVM.city?.location?.coordinates {
                setupCurrentLocationRegion(location: currentLocation)
           }
       }
    }

}

extension HomeViewController {
    
   @IBAction func resetToUserLocation() {
        showWarningDueToLackOfUserLocationPermission()
        Task {
           await getClosestCityData()
        }
   }
       
   @IBAction func refreshServerData() {
       isShowingUserLocation = false
       if let selectedCity = selectedCity {
           self.cityVM = CityViewModel(city: selectedCity)
           self.setupUI()
       } else {
           showWarningDueToLackOfUserLocationPermission()
           Task {
               await getClosestCityData()
           }
       }
   }
    
   func showWarningDueToLackOfUserLocationPermission() {
      if(!UserPermissions.shared.userLocationUsagePreference) {
          cityVM.handleServerError(StringsUtils.locationRequestDeniedString, StringsUtils.locationAuthMessageString, StringsUtils.OKString, self)
      }
   }
    
}
