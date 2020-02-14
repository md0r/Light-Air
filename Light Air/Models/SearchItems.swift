//
//  SearchItems.swift
//  Light Air
//
//  Created by Mihai on 08/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation

struct SearchItems<T: Decodable>: Decodable {
    
   let status: ResponseCodes.RawValue
   let items: [T]
  
   private enum SearchItemsKeys: String, CodingKey {
       case items = "data"
       case status
   }
       
   init(from decoder: Decoder) throws {
       let container =  try decoder.container(keyedBy: SearchItemsKeys.self)
       self.status  = try container.decode(String.self, forKey: .status)
       self.items = try container.decode(Array.self, forKey: .items)
   }
    
}
