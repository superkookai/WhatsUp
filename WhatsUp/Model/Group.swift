//
//  Group.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import Foundation

struct Group: Codable, Identifiable {
    var documentId: String? = nil
    var subject: String
    
    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension Group {
    func toDict() -> [String: Any] {
        return ["subject": subject]
    }
}
