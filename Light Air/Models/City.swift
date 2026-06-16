//
//  City.swift
//  Light Air
//
//  Created by Mihai on 04/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation

struct CityResponseWrapper: Decodable {
    
    let status: ResponseCodes.RawValue
    let city: City
     
    private enum CitiesKeys: String, CodingKey {
      case city = "data"
      case status
    }
  
    init(from decoder: Decoder) throws {
      let container =  try decoder.container(keyedBy: CitiesKeys.self)
      self.status  = try container.decode(String.self, forKey: .status)
      self.city = try container.decode(City.self, forKey: .city)
    }
    
}


struct City: Decodable {
    
    let name: String
    let state: String?
    let country: String?
    let location: CityLocation?
    let currentData: CityCurrentData?
    
    private enum CityKeys: String, CodingKey {
        case name = "city"
        case state
        case country
        case location
        case currentData = "current"
    }
    
    init(from decoder: Decoder) throws {
    
        let container =  try decoder.container(keyedBy: CityKeys.self)
      
        self.name = try container.decode(String.self, forKey: .name)
        self.state = try? container.decode(String.self, forKey: .state)
        self.country = try? container.decode(String.self, forKey: .country)
        self.location = try? container.decode(CityLocation.self, forKey: .location)
        self.currentData = try? container.decode(CityCurrentData.self, forKey: .currentData)
        
    }
    
    
}

struct CityLocation: Decodable {
    let type: String
    let coordinates: [Double]
}

struct CityCurrentData: Decodable {
    let weather: CityWeatherData
    let pollution: CityPollutionData
}

struct CityWeatherData: Decodable {
    
    let timeStamp: String?
    let temperature: Int?
    let minTemperature: Double?
    let humidity: Int?
    let windSpeed: Double?
    let windDirection: Double?
    let iconCode: String? 
    
    private enum CityWeatherKeys: String, CodingKey  {
          case timeStamp = "ts"
          case temperature = "tp"
          case minTemperature = "tp_min"
          case humidity = "hu"
          case windSpeed = "ws"
          case windDirection = "wd"
          case iconCode = "ic"
    }
    
    init(from decoder: Decoder) throws {
      
        let container =  try decoder.container(keyedBy: CityWeatherKeys.self)
        
        self.timeStamp = try? container.decode(String.self, forKey: .timeStamp)
        self.temperature = try? container.decode(Int.self, forKey: .temperature)
        self.minTemperature = try? container.decode(Double.self, forKey: .minTemperature)
        self.humidity = try? container.decode(Int.self, forKey: .humidity)
        self.windSpeed = try? container.decode(Double.self, forKey: .windSpeed)
        self.windDirection = try? container.decode(Double.self, forKey: .windDirection)
        self.iconCode = try? container.decode(String.self, forKey: .iconCode)
        
    }
    
    
}

struct CityPollutionData: Decodable {
    
    let aqius: Int?
    let mainus: String?
    let aqicn: Double?
    let maincn: String?
    
}
