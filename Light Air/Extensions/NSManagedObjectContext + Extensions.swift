//
//  NSManagedObjectContext + Extensions.swift
//  Light Air
//
//  Created by Mihai on 11/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@MainActor
extension NSManagedObjectContext {
    
    static var getCurrentViewContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}

