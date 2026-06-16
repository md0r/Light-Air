//
//  PollutionIndexViewModel.swift
//  Light Air
//
//  Created by Mihai on 10/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import UIKit

struct PollutionIndex {
        
    static let greenColor:UIColor = UIColor(displayP3Red: 169/255, green: 222/255, blue: 103/255, alpha: 1.0)
    static let redColor:UIColor = UIColor(displayP3Red: 252/255, green: 107/255, blue: 108/255, alpha: 1.0)
    static let yellowColor:UIColor = UIColor(displayP3Red: 252/255, green: 214/255, blue: 88/255, alpha: 1.0)
    static let purpleColor:UIColor = UIColor(displayP3Red: 168/255, green: 124/255, blue: 186/255, alpha: 1.0)
    static let whiteColor:UIColor = UIColor.white
    static let brandDarkGreen: UIColor = UIColor(displayP3Red: 30/255, green: 121/255, blue: 40/255, alpha: 1.0)
    static let brandGreen: UIColor = UIColor(displayP3Red: 79/255, green: 206/255, blue: 93/255, alpha: 1.0)
    
    static func getAirQualityLevel(_ pollutionIndex: Int?) -> [String:Any] {
        
        if let index = pollutionIndex {
            if(index < 20) {
                return ["quality" : PollutionLevel.excellent.description, "color" : greenColor, "fontColor" : brandDarkGreen]
            } else if (index >= 20 && index < 50) {
                return ["quality" : PollutionLevel.good.description, "color" : greenColor, "fontColor" : brandDarkGreen]
            } else if (index >= 50 && index < 100) {
                return ["quality" : PollutionLevel.moderate.description, "color" : yellowColor, "fontColor" : brandDarkGreen]
            } else if (index >= 100 && index < 200) {
                return ["quality" : PollutionLevel.unhealthy.description, "color" : redColor, "fontColor" : whiteColor]
            } else {
                return ["quality" : PollutionLevel.veryUnhealthy.description, "color" : purpleColor, "fontColor" : whiteColor]
            }
        } else {
               return ["quality" : PollutionLevel.notAvailable.description, "color" : yellowColor, "fontColor" : whiteColor]
        }
    }
}
