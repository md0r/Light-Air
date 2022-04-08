//
//  Country.swift
//  Light Air
//
//  Created by Mihai on 04/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation

struct Country: Decodable {
    let name: String
    
    private enum CountryKeys: String, CodingKey {
        case name = "country"
    }
    
    
    
    
    init(from decoder: Decoder) throws {
        let container =  try decoder.container(keyedBy: CountryKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
}
