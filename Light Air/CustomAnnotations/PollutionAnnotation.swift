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
   
    var airQuality: [String:Any] {
        PollutionIndex.shared.getAirQualityLevel(pollutionIndex)
    }
    
}
