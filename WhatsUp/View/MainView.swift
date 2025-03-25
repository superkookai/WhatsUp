//
//  MainView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        TabView {
            GroupListContainerView()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
            
            SetttingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppState())
}
