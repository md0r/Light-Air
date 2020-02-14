//
//  UserSettings.swift
//  Light Air
//
//  Created by Mihai on 14/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import CoreLocation

class UserPermissions: CLLocationManager {
    
    static let shared = UserPermissions()
    private override init() { }
    
    let defaultUserPreference: Bool = false
    let defaultErrorMessage: String = "Please authorize the app from your phone settings to use your location to get real time data about the quality of the air from your area."
    
    var userLocationUsagePreference: Bool {
        get {
            let userDefaults = UserDefaults.standard
            if let value = userDefaults.value(forKey: "locationAuth") as? Bool {
                return value
            }
            return defaultUserPreference
            
        } set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "locationAuth")
        }
    }
    
    
    var currentUserPermissionStatus: Bool? {
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                 case .notDetermined, .restricted, .denied:
                     return false
                 case .authorizedAlways, .authorizedWhenInUse:
                     return true
                 @unknown default:
                 break
             }
             } else {
                 return nil
         }
         return nil
    }
    
    
    
}
