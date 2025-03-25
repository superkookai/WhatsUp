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
    @Published var chatMessages: [ChatMessage] = []
    
    var firestoreListener: ListenerRegistration?
    
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
    
    func populateGroups() async throws {
        let snapShot = try await Firestore.firestore().collection("groups").getDocuments()
        self.groups = snapShot.documents.compactMap({ Group.fromSnapshot(snapshot: $0) })
    }
    
    func saveChatMessageToGroup(chatMessage: ChatMessage, group: Group) async throws {
        guard let groupDocumentId = group.documentId else { return }
        let _ = try await Firestore.firestore().collection("groups").document(groupDocumentId).collection("messages").addDocument(data: chatMessage.toDict())
    }
    
    func detachFirestoreListener() {
        self.firestoreListener?.remove()
    }
    
    func listenForChatMessages(in group: Group) {
        let db = Firestore.firestore()
        chatMessages.removeAll()
        guard let groupDocumentId = group.documentId else { return }
        
        self.firestoreListener = db.collection("groups").document(groupDocumentId)
            .collection("messages").order(by: "dateCreated", descending: false)
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let snapshot else {
                    print("Error listening snapshot: \(error!.localizedDescription)")
                    return
                }
                
                snapshot.documentChanges.forEach { docChange in
                    if docChange.type == .added {
                        if let chatmessage = ChatMessage.fromSnapshot(snapshot: docChange.document) {
                            if let exists = self?.chatMessages.contains(where: {$0.documentId == chatmessage.documentId}) {
                                if !exists {
                                    self?.chatMessages.append(chatmessage)
                                }
                            }
                        }
                    }
                }
        })
    }
}


//    func saveChatMessageToGroup(text: String, group: Group, completion: @escaping (Error?) -> Void) {
//        guard let groupDocumentId = group.documentId else { return }
//        Firestore.firestore().collection("groups").document(groupDocumentId).collection("messages").addDocument(data: ["chatText": text]) { error in
//            if error != nil {
//                completion(error)
//            } else {
//                completion(nil)
//            }
//        }
//    }
