//
//  PollutionAnnotation.swift
//  Light Air
//
//  Created by Mihai on 07/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import MapKit

class PollutionAnnotation: MKPointAnnotation {
    
    var pollutionIndex: Int?
       
    init(pollution: Int) {
        self.pollutionIndex = pollution
    }
   
    var airQualityDetails: [String:Any] {
        PollutionIndex.getAirQualityLevel(pollutionIndex)
    }
    
    var airQuality: String {
        if let airQuality = airQualityDetails["quality"] as? String {
            return airQuality
        }
        return "Unknown"
    }
    
    var airQualityColorLabel: UIColor {
        if let airQualityColorLabel = airQualityDetails["color"] as? UIColor {
            return airQualityColorLabel
        }
        return UIColor.red
    }
    
}
