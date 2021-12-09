//
//  Webservice.swift
//  Light Air
//
//  Created by Mihai on 02/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}


class Webservice {
    
    func getResource<T>(resource: Resource<T>, completion: @escaping (T?) -> Void) {
        
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
      
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                    
                }
                return
            }
            
            DispatchQueue.main.async {
               completion(resource.parse(data))
                
            }
            
        }.resume()
        
    }
    
}


