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
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                                 inMemoryStore: URLImageInMemoryStore())

        return WindowGroup {
            ContentView()
                .environment(\.urlImageService, urlImageService)
                //persisting favourited pokemon using core data
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            //this func adds a tap gesture recognizer to the entire app, dismissing the keyboard on tap
                .onAppear(perform:UIApplication.shared.addTapGestureRecognizer)
                
        }
        //save data when the app goes into the background
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
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
//rounded corner shape used to curve corners and borders
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}

internal extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
//custom colors used in the app
extension Color{
    static var gold : Color
    {
        get{
            return Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0)
        }
    }
    static var pokadexBackgroundColor : Color
    {
        get{
            return Color(.sRGB, red:0.6, green: 0.6, blue:0.6, opacity: 0.95)
        }
    }
    static var pokadexListColor : Color
    {
        get{
            return Color(.sRGB, red:0.9, green: 0.9, blue:0.9, opacity: 1.0 )
        }
    }
}
