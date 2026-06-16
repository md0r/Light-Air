//
//  UserSettings.swift
//  Light Air
//
//  Created by Mihai on 14/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import CoreLocation

class UserPermissions: NSObject, CLLocationManagerDelegate {
    
    static let shared = UserPermissions()
    
    private let locationManager = CLLocationManager()
    
    let defaultUserPreference: Bool = false
    
    private(set) var currentUserPermissionStatus: Bool?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        updatePermissionStatus(locationManager.authorizationStatus)
    }
    
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
    
    private func updatePermissionStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            currentUserPermissionStatus = false
        case .authorizedAlways, .authorizedWhenInUse:
            currentUserPermissionStatus = true
        @unknown default:
            currentUserPermissionStatus = nil
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updatePermissionStatus(manager.authorizationStatus)
    }
}
