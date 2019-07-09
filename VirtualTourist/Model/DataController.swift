//
//  DataController.swift
//  VirtualTourist
//
//  Created by Haya Mousa on 30/06/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController()
    
    let persistentContainer = NSPersistentContainer(name: "VirtualTourist")
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores {storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
}
