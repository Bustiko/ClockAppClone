//
//  Persistence.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 29.07.2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
          for _ in 0..<1 {
              let newItem = Alarm(context: viewContext)
              newItem.time = Date()
          }
          
          for _ in 0..<2 {
              let newItem = Chronometer(context: viewContext)
              newItem.hour = "39"
              newItem.minute = "23"
              newItem.second = "12"
          }
        
        for _ in 0..<1 {
            let newItem = WorldTime(context: viewContext)
            newItem.zoneName = "Continent/City"
            newItem.time = 1724140576
            newItem.offset = 7200
        }
          
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        return result
    }()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ClockAppClone")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
