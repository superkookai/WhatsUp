//
//  WhatsUpApp.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 24/03/2568.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

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
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appState.userSession != nil {
                    MainView()
                } else {
                    LoginView()
                }
            }
        }
        .environmentObject(model)
        .environmentObject(appState)
    }
}

//Using NavigationState with path Route

//NavigationStack(path: $appState.routes) {
//    ZStack {
//        if appState.userSession != nil {
//            MainView()
//        } else {
//            LoginView()
//        }
//    }
//    .navigationDestination(for: Route.self) { route in
//        switch route {
//        case .main:
//            MainView()
//        case .login:
//            LoginView()
//        case .signup:
//            SignupView()
//        }
//    }
//}
