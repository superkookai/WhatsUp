//
//  GroupListContainerView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI

struct GroupListContainerView: View {
    @State private var showAddNewGroup: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    showAddNewGroup = true
                } label: {
                    Text("New Group")
                }

            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showAddNewGroup) {
            AddNewGroupView()
        }
    }
}

#Preview {
    GroupListContainerView()
}
