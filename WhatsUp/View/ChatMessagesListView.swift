//
//  ChatMessagesListView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI
import FirebaseAuth

struct ChatMessagesListView: View {
    let chatMessages: [ChatMessage]
    
    private func isMessageFromCurrentUser(_ chatMessage: ChatMessage) -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }
        return chatMessage.uid == currentUser.uid
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(chatMessages) { chatMessage in
                    VStack {
                        if isMessageFromCurrentUser(chatMessage) {
                            HStack {
                                Spacer()
                                ChatMessageView(chatMessage: chatMessage, direction: .right, color: .green)
                            }
                        } else {
                            HStack {
                                ChatMessageView(chatMessage: chatMessage, direction: .left, color: .gray)
                                Spacer()
                            }
                        }
                        
                        Spacer()
                            .frame(height: 20)
                            .id(chatMessage.id)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ChatMessagesListView(chatMessages: [])
}
