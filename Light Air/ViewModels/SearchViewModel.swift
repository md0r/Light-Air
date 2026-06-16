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
    
     init() {  }
     
     init(items: [T]) {
        self.items = items
     }
    
     var returnTypeOfItemBeingFiltered: Any? {
        return items?.first
     }
    
     var searchResultsLength: Int {
        return items?.count ?? 0
     }
    
     var titleHeaderHeight: CGFloat {
        return 40
     }
    
    func saveCityData(_ city: City) {
        let _ = CoreDataManager.shared.savePollutionData(city)
     }

     func getSearchItems(index: Int) -> SearchItemViewModel<T>? {
        guard let item = items?[index] else { return nil }
        return SearchItemViewModel(item: item)
     }
    
     func getCountriesList(completion: @escaping (Any?) -> Void) {
         
        guard let url = APICalls.getAllCountriesURL else {
            return
        }
    
        let resource = Resource<Any>(url: url) { searchResponse in
            guard let searchWrapper = try? JSONDecoder().decode(SearchItems<Country>.self, from: searchResponse) else {
                   return nil
                }
            return searchWrapper.items
        }
        
        getServerData(resource: resource) { data in
            completion(data)
        }
     }
    
    
     func getStatesList(_ country: String?, completion: @escaping (Any?) -> Void) {
        
        guard let country = country else  {
            return
        }
        guard let url = APICalls.getAllStatesFromCountryURL(country: country) else {
            return
        }
        
        let resource = Resource<Any>(url: url) { searchResponse in
            guard let searchWrapper = try? JSONDecoder().decode(SearchItems<State>.self, from: searchResponse) else {
                   return nil
                }
            return searchWrapper.items
        }
        
        getServerData(resource: resource) { data in
            completion(data)
        }
        
     }
    
    
     func getCitiesList(_ country: String?, _ state: String?, completion: @escaping (Any?) -> Void) {
           
        guard let country = country, let state = state else {
            return
        }
        guard let url = APICalls.getAllCitiesFromStateURL(state: state, country: country) else {
            return
        }
        
        let resource = Resource<Any>(url: url) { searchResponse in
              guard let searchWrapper = try? JSONDecoder().decode(SearchItems<City>.self, from: searchResponse) else {
                     return nil
                  }
              return searchWrapper.items
        }
                      
        getServerData(resource: resource) { data in
            completion(data)
        }
        
     }
    
     func getCityFullDetails(_ country: String?, _ state: String?, _ city: String?, completion: @escaping (Any?) -> Void)
     {
        
        guard let country = country, let state = state, let city = city else {
            return
        }
        guard let url = APICalls.getCityData(city: city, state: state, country: country) else {
            return
        }
        
        let resource = Resource<Any>(url: url) { searchResponse in
             guard let searchWrapper = try? JSONDecoder().decode(CityResponseWrapper.self, from: searchResponse) else {
                    return nil
                 }
             return searchWrapper.city
        }
        
        getServerData(resource: resource) { data in
               completion(data)
        }
        
     }
    
     func handleServerError(_ title : String, _ message: String, _ buttonMessage: String, _ vc: UIViewController) {
        UIAlertController.showCustomAlert(title: title, message: message, buttonMessage: buttonMessage, vc: vc)
     }
    
}

extension SearchViewModel {
    
    func getServerData(resource: Resource<Any>, completion: @escaping (Any?) -> Void) {
       Webservice().getResource(resource: resource) { items in
           if let items = items  {
               completion(items)
           } else {
               completion(nil)
           }
       }
    }
       
}

struct SearchItemViewModel<T> {
    
    var item: T?

    init(item: T) {
        self.item = item
    }
    
}
