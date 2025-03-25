//
//  ChatMessage.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Codable, Identifiable, Equatable {
    var documentId: String?
    let text: String
    let uid: String
    var dateCreated = Date()
    let displayName: String
    
    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension ChatMessage {
    func toDict() -> [String: Any] {
        return [
            "text": text,
            "uid": uid,
            "dateCreated": dateCreated,
            "displayName": displayName
        ]
    }
    
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let dict = snapshot.data()
        guard let text = dict["text"] as? String,
              let uid = dict["uid"] as? String,
              let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue(),
              let displayName = dict["displayName"] as? String else {
            return nil
        }
        return ChatMessage(documentId: snapshot.documentID, text: text, uid: uid, dateCreated: dateCreated, displayName: displayName)
    }
}
