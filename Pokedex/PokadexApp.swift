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
            //this func adds a tap gesture recognizer to the entire app, dismissing the keyboard on tap
                .onAppear(perform:UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
//extensions that add a gesture recognizer to app that dismisses keyboard on tap
extension UIApplication {
    func addTapGestureRecognizer()
    {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
