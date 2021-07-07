//
//  Persistence.swift
//  Pokedex
//
//  Created by David Lockwood on 28/06/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    //persisting favourited pokemon
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let newItem = PokemonFavourite(context: viewContext)
        newItem.name = "charmander"
       
        do {
            try viewContext.save()
        } catch {
            // TODO - error handling
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Pokedex")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               //TODO - error handling
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    //this function is called to save any changes made. Only actually writen to disk if changes made.
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO - error handling
            }
        }
    }
}
