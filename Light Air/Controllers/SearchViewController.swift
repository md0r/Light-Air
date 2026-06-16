//
//  SearchViewController.swift
//  Light Air
//
//  Created by Mihai on 05/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var searchVM = SearchViewModel<Any>()
    private var localCachedCountryParameter:String = String()
    private var localCachedStateParameter:String = String()
    private var headingTitle: String  = String()
    private var brandGreenColor: UIColor = UIColor(displayP3Red: 79/255, green: 206/255, blue: 93/255, alpha: 1.0)
    
    private var cancellables = Set<AnyCancellable>()
    @Published private var searchQuery: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.addHeaderImageToNavigationController(sender: self, width: 30, height: 30)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        setupSearchSubscription()
        
        Task {
            await getCountries()
        }
    }
    
    private func setupSearchSubscription() {
       $searchQuery
           .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
           .removeDuplicates()
           .sink { [weak self] query in
               guard let self = self else { return }
               self.searchVM.filterItems(query: query)
               self.tableView.reloadData()
           }
           .store(in: &cancellables)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       searchQuery = searchText
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()
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
            Task {
                await getStates()
            }
        }
        
        if let state = searchItem?.item as? State {
           localCachedStateParameter = state.name
            Task {
                await getCities()
            }
        }
        
        if let city = searchItem?.item as? City {
            Task {
                await getCityDetails(city.name)
            }
        }
    
    }
    
}


extension SearchViewController {
    
    func getCountries() async {
       hideTableView()
       let countries = await searchVM.getCountriesList()
        if let items = countries {
             self.showTableView("SELECT COUNTRY:", items)
             searchBar.placeholder = "Search country..."
        } else {
             self.handleServerError()
        }
    }
    
    func getStates() async {
        hideTableView()
        let states = await searchVM.getStatesList(localCachedCountryParameter)
        if let items = states {
            self.showTableView("SELECT STATE/REGION:", items)
            searchBar.placeholder = "Search state..."
        } else {
            self.handleServerError()
        }
    }
    
    func getCities() async {
        hideTableView()
        let cities =  await searchVM.getCitiesList(localCachedCountryParameter, localCachedStateParameter)
        if let items = cities {
           self.showTableView("SELECT CITY/AREA:", items)
            searchBar.placeholder = "Search city..."
        } else {
           self.handleServerError()
        }
    }
    
    func getCityDetails(_ cityName: String) async {
        hideTableView()
        let city = await searchVM.getCityFullDetails(localCachedCountryParameter, localCachedStateParameter, cityName)
        if let city = city {
            self.navigateToHomeViewController(city)
            self.searchVM.saveCityData(city)
        } else {
            self.handleServerError()
        }
    }
    
    @IBAction func resetFilters() {
        Task {
            await getCountries()
        }
    }
    
    @IBAction func goBackToPreviousFilterLevel() {
        let currentItemInList = searchVM.returnTypeOfItemBeingFiltered
        if currentItemInList is City {
            Task {
                await  getStates()
            }
        }
        if currentItemInList is State {
            Task {
                await getCountries()
            }
        }
    }
    
    func showTableView(_ tableHeaderLabel: String, _ items: [Any]) {
        searchBar.text = ""
        searchQuery = ""
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
        searchVM.handleServerError(StringsUtils.limitReachedString, StringsUtils.pleaseTryAgainString, StringsUtils.OKString, self)
    }
    
}
