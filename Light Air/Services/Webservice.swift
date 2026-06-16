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

struct Webservice {
    
    func getResource<T>(resource: Resource<T>) async throws -> T? {
          let (data, _) = try await URLSession.shared.data(from: resource.url)
          guard let parsedResource = resource.parse(data) else {
              throw URLError(.badServerResponse)
          }
          return parsedResource
    }
    
}


