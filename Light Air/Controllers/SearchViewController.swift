//
//  SearchViewController.swift
//  Light Air
//
//  Created by Mihai on 05/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goBackToPreviousFilterButton: UIBarButtonItem!
    
    private var searchVM = SearchViewModel<Any>()
    private var localCachedCountryParameter:String = String()
    private var localCachedStateParameter:String = String()
    private var headingTitle: String  = String()
    private var brandGreenColor: UIColor = UIColor(displayP3Red: 79/255, green: 206/255, blue: 93/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goBackToPreviousFilterButton.tintColor = brandGreenColor
        ThemeManager.addHeaderImageToNavigationController(sender: self, width: 30, height: 30)
        tableView.delegate = self
        tableView.dataSource = self
        getCountries()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = (searchVM.searchResultsLength > 0) ? false : true
        return searchVM.searchResultsLength
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchVM.titleHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchOptionsCellId", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let searchItem = searchVM.getSearchItems(index: indexPath.row)
        
        if let result = searchItem?.item as? Country {
            cell.textLabel?.text = result.name
        }
        if let result = searchItem?.item as? State {
            cell.textLabel?.text = result.name
        }
        if let result = searchItem?.item as? City {
            cell.textLabel?.text = result.name
        }
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.getHeaderForTableView(tableView: tableView)
        let label = UILabel.getHeaderLabelForTableView(parentView: headerView)
        label.text = headingTitle
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let searchItem = searchVM.getSearchItems(index: indexPath.row)
        
        if let country = searchItem?.item as? Country {
           localCachedCountryParameter = country.name
           getStates()
        }
        
        if let state = searchItem?.item as? State {
           localCachedStateParameter = state.name
           getCities()
        }
        
        if let city = searchItem?.item as? City {
           getCityDetails(city.name)
        }
    
    }
    
}


extension SearchViewController {
    
    func getCountries() {
       hideTableView()
       searchVM.getCountriesList { items in
           if let items = items as? [Country] {
                self.showTableView("SELECT COUNTRY:", items)
                self.goBackToPreviousFilterButton.tintColor = self.brandGreenColor
           } else {
                self.handleServerError()
           }
       }
    }
    
    func getStates() {
        hideTableView()
        searchVM.getStatesList(localCachedCountryParameter) { items in
            if let items = items as? [State] {
                self.showTableView("SELECT STATE/REGION:", items)
                self.goBackToPreviousFilterButton.tintColor = UIColor.white
            } else {
                self.handleServerError()
            }
        }
    }
    
    func getCities() {
        hideTableView()
        searchVM.getCitiesList(localCachedCountryParameter, localCachedStateParameter) { items in
           if let items = items as? [City] {
              self.showTableView("SELECT CITY/AREA:", items)
           } else {
              self.handleServerError()
           }
        }
    }
    
    func getCityDetails(_ cityName: String) {
        hideTableView()
        searchVM.getCityFullDetails(localCachedCountryParameter, localCachedStateParameter, cityName) { city in
           if let city = city as? City {
               self.navigateToHomeViewController(city)
               self.searchVM.saveCityData(city)
           } else {
               self.handleServerError()
           }
        }
    }
    
    @IBAction func resetFilters() {
        getCountries()
    }
    
    @IBAction func goBackToPreviousFilterLevel() {
        let currentItemInList = searchVM.returnTypeOfItemBeingFiltered
        if currentItemInList is City {
           getStates()
        }
        
        if currentItemInList is State {
           getCountries()
        }
    }
    
    func showTableView(_ tableHeaderLabel: String, _ items: [Any]) {
        searchVM = SearchViewModel(items: items)
        headingTitle = tableHeaderLabel
        tableView.reloadData()
        tableView.alpha = 1
        activityIndicator.isHidden = true
    }
    
    func hideTableView() {
        tableView.alpha = 0
        activityIndicator.isHidden = false
    }
    
    func navigateToHomeViewController(_ city: City) {
          tableView.alpha = 1
          self.activityIndicator.isHidden = true

          guard let destinationVC = self.tabBarController?.viewControllers?[0] as? UINavigationController,
                let homeVC = destinationVC.viewControllers[0] as? HomeViewController
          else {
            return
          }
        
          homeVC.selectedCity = city
          self.tabBarController?.selectedIndex = 0
    }
    
    func handleServerError() {
        tableView.alpha = 1
        activityIndicator.isHidden = true
        UIAlertController.showCustomAlert(title: "Server Error", message: "Please try again later.", buttonMessage: "OK", vc: self)
    }
    
}
