//
//  GroupListContainerView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI

struct GroupListContainerView: View {
    @State private var showAddNewGroup: Bool = false
    
    @EnvironmentObject private var model: Model
    
    var body: some View {
        NavigationStack {
            List(model.groups) { group in
                NavigationLink {
                    GroupDetailView(group: group)
                } label: {
                    HStack {
                        Image(systemName: "person.2")
                        Text(group.subject)
                            .font(.title)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Groups")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddNewGroup = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            })
        }
        .sheet(isPresented: $showAddNewGroup) {
            AddNewGroupView()
        }
        .task {
            do {
                try await model.populateGroups()
            } catch {
                print("Error fetching groups: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    GroupListContainerView()
        .environmentObject(Model())
}
