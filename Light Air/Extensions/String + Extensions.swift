//
//  String + Extensions.swift
//  Light Air
//
//  Created by Mihai on 08/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation


extension String {
    
     func getCleanedURL() -> URL? {
        
        var stringToReturn = self
        
        if stringToReturn.contains("SAR") {
            if let range = stringToReturn.range(of: "SAR") {
               stringToReturn.removeSubrange(range)
            }
        }
        
        if stringToReturn.contains("United Kingdom") {
            stringToReturn = stringToReturn.replacingOccurrences(of: "United Kingdom", with: "UK")
        }
        
        guard stringToReturn.isEmpty == false else {
            return nil
        }
        
        if let url = URL(string: stringToReturn) {
            return url
        } else {
            if let urlEscapedString = stringToReturn.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
                return escapedURL
            }
        }
        return nil
   }
    
}
