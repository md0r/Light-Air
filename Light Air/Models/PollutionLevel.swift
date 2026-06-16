//
//  Pollution.swift
//  Light Air
//
//  Created by Mihai Dorhan on 16/06/2026.
//  Copyright © 2026 Mihai Dorhan. All rights reserved.
//
import Foundation

enum PollutionLevel {
  
    case excellent
    case good
    case moderate
    case unhealthy
    case veryUnhealthy
    case notAvailable
    
    var description:String {
        switch self {
            case .excellent:
                return "Excellent"
            case .good:
                return "Good"
            case .moderate:
                return "Moderate"
            case .unhealthy:
                return "Unhealthy"
            case .veryUnhealthy:
                return "Very Unhealthy"
            case .notAvailable:
                return "N/A"
        }
    }

}



