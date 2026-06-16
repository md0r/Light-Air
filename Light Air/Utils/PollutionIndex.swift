//
//  PollutionIndexViewModel.swift
//  Light Air
//
//  Created by Mihai on 10/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import UIKit

class PollutionIndex {
    
    static let shared =  PollutionIndex()
    private init() {}
    
    let greenColor:UIColor = UIColor(displayP3Red: 169/255, green: 222/255, blue: 103/255, alpha: 1.0)
    let redColor:UIColor = UIColor(displayP3Red: 252/255, green: 107/255, blue: 108/255, alpha: 1.0)
    let yellowColor:UIColor = UIColor(displayP3Red: 252/255, green: 214/255, blue: 88/255, alpha: 1.0)
    let purpleColor:UIColor = UIColor(displayP3Red: 168/255, green: 124/255, blue: 186/255, alpha: 1.0)
    
    let whiteColor:UIColor = UIColor.white
    let brandDarkGreen: UIColor = UIColor(displayP3Red: 30/255, green: 121/255, blue: 40/255, alpha: 1.0)
    let brandGreen: UIColor = UIColor(displayP3Red: 79/255, green: 206/255, blue: 93/255, alpha: 1.0)
    
    func getAirQualityLevel(_ pollutionIndex: Int?) -> [String:Any] {
        
        if let index = pollutionIndex {
            if(index < 20) {
                return ["quality" : "Excellent", "color" : greenColor, "fontColor" : brandDarkGreen]
            } else if (index >= 20 && index < 50) {
                return ["quality" : "Good", "color" : greenColor, "fontColor" : brandDarkGreen]
            } else if (index >= 50 && index < 100) {
                return ["quality" : "Moderate", "color" : yellowColor, "fontColor" : brandDarkGreen]
            } else if (index >= 100 && index < 200) {
                return ["quality" : "Unhealthy", "color" : redColor, "fontColor" : whiteColor]
            } else {
                return ["quality" : "Very Unhealthy", "color" : purpleColor, "fontColor" : whiteColor]
            }
        } else {
               return ["quality" : "N/A", "color" : yellowColor, "fontColor" : whiteColor]
        }
        
    }
    
}
