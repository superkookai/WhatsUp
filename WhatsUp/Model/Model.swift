//
//  Model.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 24/03/2568.
//

import Foundation
import FirebaseAuth

@MainActor
class Model: ObservableObject {
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
    }
}
