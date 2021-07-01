//
//  PokedexApp.swift
//  Pokedex
//
//  Created by David Lockwood on 28/06/2021.
//

import SwiftUI
import URLImage
import URLImageStore
@main
struct PokedexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                                 inMemoryStore: URLImageInMemoryStore())

               return WindowGroup {
                ContentView()
                    .environment(\.urlImageService, urlImageService)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
               }
       
    }
}
