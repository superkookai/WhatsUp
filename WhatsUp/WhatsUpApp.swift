//
//  WhatsUpApp.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 24/03/2568.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct WhatsUpApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var model = Model()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            SignupView()
        }
        .environmentObject(model)
    }
}
