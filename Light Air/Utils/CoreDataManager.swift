//
//  CoreDataManager.swift
//  Light Air
//
//  Created by Mihai on 11/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import CoreData

@MainActor
class CoreDataManager {
    
    static let shared = CoreDataManager(moc: NSManagedObjectContext.getCurrentViewContext)
    
    var moc: NSManagedObjectContext
    
    private init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
        
    func savePollutionData(_ city: City) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z"
        
        guard let state = city.state, let country = city.country, let pollution = city.currentData?.pollution.aqius, let timeStamp = city.currentData?.weather.timeStamp else {
            return false
        }
        
        let cityData = CityData(context: self.moc)
    
        cityData.name = city.name
        cityData.state = state
        cityData.country = country
        cityData.pollution = Int16(pollution)
        cityData.timestamp = dateFormatter.date(from: timeStamp)
        
        do {
            try self.moc.save()
            return true
        }
        catch _ as NSError {
            return false
        }
        
    }
    
    
    func getAllPollutionData() -> [CityData] {
        
        var cityDataArray = [CityData]()
        let cityDataRequest: NSFetchRequest<CityData> = CityData.fetchRequest()
        
        do {
            cityDataArray = try self.moc.fetch(cityDataRequest)
        } catch _ as NSError {
           
        }
        return cityDataArray.reversed()
    }
    
    
    func deleteAllPollutionData() -> Bool {
        
        let deleteAllData = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "CityData"))
        do {
           try self.moc.execute(deleteAllData)
           return true
        } catch _ as NSError {
           return false
        }
        
    }
    
}
