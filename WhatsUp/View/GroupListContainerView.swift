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
                        
                        Spacer()
                        
                        if let messageCount = model.groupMessageCount[group.subject.lowercased()], messageCount > 0 {
                            ZStack {
                                Circle()
                                    .fill(.green.opacity(0.5))
                                    .frame(width: 30)
                                
                                Text("\(messageCount)")
                            }
                        }
                    }
                    .onAppear {
                        model.listenForNewChatCount(in: group)
                        print("Group Row Appear")
                    }
                    .onDisappear {
                        model.detachFirestoreNewChatCountListener(for: group)
                        print("Group Row Disappear")
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
        .onAppear {
            model.listenForGroups()
            print("Group List Appear")
        }
        .onDisappear {
            model.detachFirestoreGroupListener()
            print("Group List Disappear")
        }
    }
}

#Preview {
    GroupListContainerView()
        .environmentObject(Model())
}
