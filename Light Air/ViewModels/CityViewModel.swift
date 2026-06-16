//
//  CityViewModel.swift
//  Light Air
//
//  Created by Mihai on 07/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import UIKit
import Foundation

@MainActor
struct CityViewModel {
    
    var city: City?
     
    init() { }
    
    init(city: City) {
        self.city = city
    }
    
    var cityName: String? {
        return city?.name
    }
    
    var temperature: String? {
        return "\(city?.currentData?.weather.temperature ?? 0)°C"
    }
    
    var humidity: String? {
        return "\(city?.currentData?.weather.humidity ?? 0)%"
    }
    
    var iconCode: String? {
        return city?.currentData?.weather.iconCode
    }
    
    var state: String? {
        return city?.state
    }
    
    var country: String? {
        return city?.country
    }
    
    var location:Array<Double>? {
        return city?.location?.coordinates
    }
    
    var pollutionLevel: Int? {
         return city?.currentData?.pollution.aqius
    }
    
    var pollutionDetails: [String: Any] {
        PollutionIndex.getAirQualityLevel(city?.currentData?.pollution.aqius)
    }
    
    var airQuality: String {
        if let airQuality = pollutionDetails["quality"] as? String {
            return "Air Quality: \(airQuality)"
        }
        return "Air Quality: Unknown"
    }
    
    var airQualityBg: UIColor {
        if let airQualityBg = pollutionDetails["color"] as? UIColor {
            return airQualityBg
        }
        return .systemRed
    }
    
    var airQualityFontColor: UIColor {
        if let airQualityFontColor = pollutionDetails["fontColor"] as? UIColor {
            return airQualityFontColor
        }
        return .white
    }
    
    func saveCityData(_ city: City) {
         let _ = CoreDataManager.shared.savePollutionData(city)
    }

    func getCityData(completion: @escaping (City?) -> Void) {
        
         guard let url = APICalls.getNearestCityDataByIP else {
            return
         }
        
         let resource = Resource<City>(url: url) { cityServerResponse in
             guard let cityWrapper = try? JSONDecoder().decode(CityResponseWrapper.self, from: cityServerResponse) else {
                 return nil
             }
             return cityWrapper.city
         }
             
         Webservice().getResource(resource: resource) { city in
             if let city = city {
                 completion(city)
             } else {
                 completion(nil)
            }
         }
        
    }
    
    func handleServerError(_ title : String, _ message: String, _ buttonMessage: String, _ vc: UIViewController) {
        UIAlertController.showCustomAlert(title: title, message: message, buttonMessage: buttonMessage, vc: vc)
    }
    
}
