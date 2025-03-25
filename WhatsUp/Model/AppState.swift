//
//  AppState.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import Foundation
import FirebaseAuth

enum Route: Hashable {
    case main
    case login
    case signup
}

class AppState: ObservableObject {
    @Published var routes: [Route] = []
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        loadUser()
    }
    
    private func loadUser() {
        self.userSession = Auth.auth().currentUser
    }
}
