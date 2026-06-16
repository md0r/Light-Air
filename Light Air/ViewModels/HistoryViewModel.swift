//
//  HistoryViewModel.swift
//  Light Air
//
//  Created by Mihai on 11/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import UIKit

@MainActor
struct HistoryItemsViewModel {
    
    var historyItems = [HistoryItemVM]()
    init() { }
    
    mutating func fetchAllHistoryData() {
        historyItems = CoreDataManager.shared.getAllPollutionData().map(HistoryItemVM.init)
    }
    
    func deleteAllHistoryData() {
        let _ = CoreDataManager.shared.deleteAllPollutionData()
    }
    
}

struct HistoryItemVM {

    let dateFormatter = DateFormatter()
    
    let name: String?
    let country: String?
    let state: String?
    let pollution: Int?
    var timestamp: String = ""
    
    init(cityData: CityData) {
        self.name = cityData.name
        self.country = cityData.country
        self.state = cityData.state
        self.pollution =  Int(cityData.pollution)
        
        if let timestamp = cityData.timestamp {
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "dd/MMM"
            self.timestamp = dateFormatter.string(from: timestamp)
        } 
        
    }
    
    var pollutionDetailsData: [String:Any] {
        PollutionIndex.getAirQualityLevel(pollution)
    }
    
    var airQuality: String? {
        return pollutionDetailsData["quality"] as? String
    }
    
    var airQualityBgColor: UIColor? {
        return pollutionDetailsData["color"] as? UIColor
    }
    
    var airQualityFontColor: UIColor? {
        return pollutionDetailsData["fontColor"] as? UIColor
    }
    
}
