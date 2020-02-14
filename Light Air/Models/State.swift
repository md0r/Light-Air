//
//  State.swift
//  Light Air
//
//  Created by Mihai on 04/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation

struct State: Decodable {
    let name: String
    
    private enum StateKeys: String, CodingKey {
        case name = "state"
    }
    
    init(from decoder: Decoder) throws {
        let container =  try decoder.container(keyedBy: StateKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
}
