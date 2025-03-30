//
//  PersistanceController.swift
//  Consumption
//
//  Created by Morris-Stiff R O (FCES) on 29/03/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Consumption")
        
        if let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.usw.rms.Consumption") {
            let storeURL = appGroupURL.appendingPathComponent("Consumption.sqlite")
            let description = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [description]
        }
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
