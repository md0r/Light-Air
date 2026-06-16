//
//  Settings.swift
//  Light Air
//
//  Created by Mihai on 02/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation

struct StringsUtils {
    
    static let locationRequestDeniedString: String = "Location Request Denied"
    static let limitReachedString: String = "Limit reached"
    static let pleaseTryAgainString: String = "You have reached the maximum allowed API calls per minute. Please try again in a few minutes."
    static let OKString: String = "OK"
    static let locationAuthMessageString = "Light Air needs to know your location to show you the quality of the air from your area."
    
}

struct APICalls {
    
    static let APIKey: String =  ""
   
    static var getAllCountriesURL: URL? {
        return "https://api.airvisual.com/v2/countries?key=\(self.APIKey)".getCleanedURL()
    }
    
    static var getNearestCityDataByIP: URL? {
        return "https://api.airvisual.com/v2/nearest_city?key=\(self.APIKey)".getCleanedURL()
    }
    
    static func getCityData(city: String, state: String, country: String) -> URL? {
        return "https://api.airvisual.com/v2/city?city=\(city)&state=\(state)&country=\(country)&key=\(APICalls.APIKey)".getCleanedURL()
    }
    
    static func getAllStatesFromCountryURL(country: String) -> URL?  {
        return "https://api.airvisual.com/v2/states?country=\(country)&key=\(APICalls.APIKey)".getCleanedURL()
    }
    
    static func getAllCitiesFromStateURL(state: String, country: String) -> URL?  {
        return "https://api.airvisual.com/v2/cities?state=\(state)&country=\(country)&key=\(APICalls.APIKey)".getCleanedURL()
    }
    
    static func getNearestCityDataByGPS(lat: String, long: String) -> URL? {
        return "api.airvisual.com/v2/nearest_city?lat=\(lat)&lon=\(long)&key=\(APICalls.APIKey)".getCleanedURL()
    }
    
}
