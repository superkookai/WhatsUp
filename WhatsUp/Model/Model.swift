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
    @Published var groupMessageCount: [String: Int] = [:]
    
    var firestoreGroupListener: ListenerRegistration?
    var firestoreChatMessagesListener: ListenerRegistration?
//    var firestoreNewChatCountListener: ListenerRegistration?
    var firestoreNewChatCountListener: [String: ListenerRegistration] = [:]
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["displayName": displayName])
    }
    
    func uploadPhotoURL(for user: User, photoURL: URL) async throws {
        let request = user.createProfileChangeRequest()
        request.photoURL = photoURL
        try await request.commitChanges()
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["profilePhotoURL": photoURL.absoluteString])
    }
    
    private func updateUserInfoForAllMessages(uid: String, updatedInfo: [AnyHashable: Any]) async throws {
        let db = Firestore.firestore()
        let groupDocuments = try await db.collection("groups").getDocuments().documents
        for groupDoc in groupDocuments {
            let messages = try await groupDoc.reference.collection("messages").whereField("uid", isEqualTo: uid).getDocuments().documents
            for message in messages {
                try await message.reference.updateData(updatedInfo)
            }
        }
    }
    
    func addGroup(group: Group) async throws {
        try await Firestore.firestore().collection("groups").addDocument(data: group.toDict())
    }
    
    func populateGroups() async throws {
        let snapShot = try await Firestore.firestore().collection("groups").getDocuments()
        self.groups = snapShot.documents.compactMap({ Group.fromSnapshot(snapshot: $0) })
    }
    
    func saveChatMessageToGroup(chatMessage: ChatMessage, group: Group) async throws {
        guard let groupDocumentId = group.documentId else { return }
        let _ = try await Firestore.firestore().collection("groups").document(groupDocumentId).collection("messages").addDocument(data: chatMessage.toDict())
        
    }
    
    func getNumberOfChatMessages(in group: Group) async throws -> Int? {
        guard let groupDocumentId = group.documentId else { return nil }
        return try await Firestore.firestore().collection("groups").document(groupDocumentId).collection("messages").getDocuments().count
    }
    
    
    //MARK: - Listener for Number of new ChatMessages
    func detachFirestoreNewChatCountListener(for group: Group) {
        self.groupMessageCount[group.subject.lowercased()] = 0
        self.firestoreNewChatCountListener[group.subject.lowercased()]?.remove()
    }
    
    func listenForNewChatCount(in group: Group) {
        let db = Firestore.firestore()
        guard let groupDocumentId = group.documentId else { return }
        
        self.groupMessageCount[group.subject.lowercased()] = 0
        
        self.firestoreNewChatCountListener[group.subject.lowercased()] = db.collection("groups").document(groupDocumentId)
            .collection("messages").order(by: "dateCreated", descending: false)
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let snapshot else {
                    print("Error listening snapshot: \(error!.localizedDescription)")
                    return
                }
                
                snapshot.documentChanges.forEach { docChange in
                    if docChange.type == .added {
                        self?.groupMessageCount[group.subject.lowercased()] = snapshot.documentChanges.count
                    } 
                }
        })
    }
    
    //MARK: - Listener for ChatMessages
    func detachFirestoreChatMessageListener() {
        self.firestoreChatMessagesListener?.remove()
    }
    
    func listenForChatMessages(in group: Group) {
        let db = Firestore.firestore()
        chatMessages.removeAll()
        guard let groupDocumentId = group.documentId else { return }
        
        self.firestoreChatMessagesListener = db.collection("groups").document(groupDocumentId)
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
    
    //MARK: - Listener for Group
    
    func detachFirestoreGroupListener() {
        self.firestoreGroupListener?.remove()
    }
    
    func listenForGroups() {
        groups.removeAll()
        self.firestoreGroupListener?.remove()
        self.firestoreGroupListener = Firestore.firestore().collection("groups").addSnapshotListener({ [weak self] snapshot, error in
            guard let snapshot else {
                print("Error listening snapshot: \(error!.localizedDescription)")
                return
            }
            
            snapshot.documentChanges.forEach { docChange in
                if docChange.type == .added {
                    if let group = Group.fromSnapshot(snapshot: docChange.document) {
                        if let exists = self?.groups.contains(where: {$0.documentId == group.documentId}) {
                            if !exists {
                                self?.groups.append(group)
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

//    func addGroup(group: Group, completion: @escaping (Error?) -> Void) {
//        let db = Firestore.firestore()
//        var docRef: DocumentReference? = nil
//        docRef = db.collection("groups").addDocument(data: group.toDict()) { [weak self] error in
//            if error != nil {
//                completion(error)
//            } else {
//                if let docRef {
//                    var newGroup = group
//                    newGroup.documentId = docRef.documentID
//                    self?.groups.append(newGroup)
//                }
//                completion(nil)
//            }
//        }
//    }
