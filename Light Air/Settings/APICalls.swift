//
//  Settings.swift
//  Light Air
//
//  Created by Mihai on 02/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation


class APICalls {
    
    static let shared =  APICalls()
    private init() {}
    
    let APIKey: String =  "7856fbe2-2104-49c1-a500-9d65ad607442"
   
    var getAllCountriesURL: URL? {
        return "https://api.airvisual.com/v2/countries?key=\(self.APIKey)".getCleanedURL()
    }
    
    var getNearestCityDataByIP: URL? {
        return "https://api.airvisual.com/v2/nearest_city?key=\(self.APIKey)".getCleanedURL()
    }
    
    func getCityData(city: String, state: String, country: String) -> URL? {
        return "https://api.airvisual.com/v2/city?city=\(city)&state=\(state)&country=\(country)&key=\(self.APIKey)".getCleanedURL()
    }
    
    func getAllStatesFromCountryURL(country: String) -> URL?  {
        return "https://api.airvisual.com/v2/states?country=\(country)&key=\(self.APIKey)".getCleanedURL()
    }
    
    func getAllCitiesFromStateURL(state: String, country: String) -> URL?  {
        return "https://api.airvisual.com/v2/cities?state=\(state)&country=\(country)&key=\(self.APIKey)".getCleanedURL()
    }
    
    func getNearestCityDataByGPS(lat: String, long: String) -> URL? {
        return "api.airvisual.com/v2/nearest_city?lat=\(lat)&lon=\(long)&key=\(self.APIKey)".getCleanedURL()
    }
    

}
