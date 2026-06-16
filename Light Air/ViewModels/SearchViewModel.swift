//
//  SearchViewModel.swift
//  Light Air
//
//  Created by Mihai on 08/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import UIKit

@MainActor
struct SearchViewModel<T> {
    
     var items: [T]?
     private var filteredItems: [T]?
    
     init() {  }
     
     init(items: [T]) {
        self.items = items
     }
    
     var returnTypeOfItemBeingFiltered: Any? {
        return items?.first
     }
    
     var searchResultsLength: Int {
         if let filteredItems = filteredItems {
             return filteredItems.count
         } else {
             return items?.count ?? 0
         }
     }
    
     var titleHeaderHeight: CGFloat {
        return 40
     }
    
     mutating func filterItems(query: String) {
        guard !query.isEmpty else {
            filteredItems = items
            return
        }
        filteredItems = items?.filter { searchItem in
             let lowercasedQuery = query.lowercased()
             if let country = searchItem as? Country {
                 return country.name.lowercased().hasPrefix(lowercasedQuery)
             }
             if let state = searchItem as? State {
                 return state.name.lowercased().hasPrefix(lowercasedQuery)
             }
             if let city = searchItem as? City {
                 return city.name.lowercased().hasPrefix(lowercasedQuery)
             }
             return false
        }
     }
    
     func saveCityData(_ city: City) {
        let _ = CoreDataManager.shared.savePollutionData(city)
     }

     func getSearchItems(index: Int) -> SearchItemViewModel<T>? {
         if let filteredItems = filteredItems {
             guard index >= 0 && index < filteredItems.count else { return nil }
             print(index)
             print(filteredItems)
             return SearchItemViewModel(item: filteredItems[index])
         } else {
             guard let item = items?[index] else { return nil }
             return SearchItemViewModel(item: item)
         }
     }
    
     func getCountriesList() async -> [Country]? {
        guard let url = APICalls.getAllCountriesURL else {
            return nil
        }
        let resource = Resource<Any>(url: url) { searchResponse in
            guard let searchWrapper = try? JSONDecoder().decode(SearchItems<Country>.self, from: searchResponse) else {
                   return nil
                }
            return searchWrapper.items
        }
        return await getServerData(resource: resource) as? [Country]
     }
    
     func getStatesList(_ country: String?) async -> [State]? {
        guard let country = country else  {
            return nil
        }
        guard let url = APICalls.getAllStatesFromCountryURL(country: country) else {
            return nil
        }
        let resource = Resource<Any>(url: url) { searchResponse in
            guard let searchWrapper = try? JSONDecoder().decode(SearchItems<State>.self, from: searchResponse) else {
                   return nil
                }
            return searchWrapper.items
        }
        return await getServerData(resource: resource) as? [State]
     }
    
     func getCitiesList(_ country: String?, _ state: String?) async -> [City]? {
        guard let country = country, let state = state else {
            return nil
        }
        guard let url = APICalls.getAllCitiesFromStateURL(state: state, country: country) else {
            return nil
        }
        let resource = Resource<Any>(url: url) { searchResponse in
              guard let searchWrapper = try? JSONDecoder().decode(SearchItems<City>.self, from: searchResponse) else {
                     return nil
                  }
              return searchWrapper.items
        }
        return await getServerData(resource: resource) as? [City]
     }
    
     func getCityFullDetails(_ country: String?, _ state: String?, _ city: String?) async -> City? {
        guard let country = country, let state = state, let city = city else {
            return nil
        }
        guard let url = APICalls.getCityData(city: city, state: state, country: country) else {
            return nil
        }
        let resource = Resource<Any>(url: url) { searchResponse in
             guard let searchWrapper = try? JSONDecoder().decode(CityResponseWrapper.self, from: searchResponse) else {
                    return nil
                 }
             return searchWrapper.city
        }
        return await getServerData(resource: resource) as? City
     }
    
     func handleServerError(_ title : String, _ message: String, _ buttonMessage: String, _ vc: UIViewController) {
        UIAlertController.showCustomAlert(title: title, message: message, buttonMessage: buttonMessage, vc: vc)
     }
    
}

extension SearchViewModel {
    
    func getServerData(resource: Resource<Any>) async -> Any? {
        do {
            return try await Webservice().getResource(resource: resource)
        }
        catch {
            return nil
        }
    }
       
}

struct SearchItemViewModel<T> {
    
    var item: T?
    
    init(item: T) {
        self.item = item
    }
    
}
