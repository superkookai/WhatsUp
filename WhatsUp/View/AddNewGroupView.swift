//
//  AddNewGroupView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI

struct AddNewGroupView: View {
    @State private var groupSubject: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var model: Model
    
    private var isFormValid: Bool {
        !groupSubject.isEmptyOrWhiteSpace
    }
    
    private func addGroup() {
        let group = Group(subject: groupSubject)
        model.addGroup(group: group) { error in
            if let error {
                print("Error add new group: \(error.localizedDescription)")
            }
        }
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Group Subject", text: $groupSubject)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add New Group")
                        .bold()
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addGroup()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

#Preview {
    AddNewGroupView()
        .environmentObject(Model())
}
