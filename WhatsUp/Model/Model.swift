//
//  Model.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 24/03/2568.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class Model: ObservableObject {
    
    @Published var groups: [Group] = []
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
    }
    
    func addGroup(group: Group, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("groups").addDocument(data: group.toDict()) { [weak self] error in
            if error != nil {
                completion(error)
            } else {
                if let docRef {
                    var newGroup = group
                    newGroup.documentId = docRef.documentID
                    self?.groups.append(newGroup)
                }
                completion(nil)
            }
        }
    }
}
