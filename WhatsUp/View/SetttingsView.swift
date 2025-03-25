//
//  SetttingsView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI
import FirebaseAuth

struct SetttingsView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                
                Button {
                    signOut()
                } label: {
                    Text("SignOut")
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Settings")
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            appState.userSession = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SetttingsView()
        .environmentObject(AppState())
}
