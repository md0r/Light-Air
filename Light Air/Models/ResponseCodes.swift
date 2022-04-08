//
//  ResponseCodes.swift
//  Light Air
//
//  Created by Mihai on 04/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation

enum ResponseCodes: String, CaseIterable, Decodable {
   
    
    case success = "success"
    case fail = "fail"
    case call_limit_reached = "call_limit_reached"
    case api_key_expired = "api_key_expired"
    case incorrect_api_key = "incorrect_api_key"
    case ip_location_failed = "ip_location_failed"
    case no_nearest_station = "no_nearest_station"
    case feature_not_available = "feature_not_available"
    case too_many_requests = "too_many_requests"
    
}
