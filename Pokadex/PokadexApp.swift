//
//  PokadexApp.swift
//  Pokadex
//
//  Created by David Lockwood on 28/06/2021.
//

import SwiftUI

@main
struct PokadexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
