//
//  ChatMessagesListView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI

struct ChatMessagesListView: View {
    let chatMessages: [ChatMessage]
    
    var body: some View {
        List(chatMessages) { chatMessage in
            Text(chatMessage.text)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    ChatMessagesListView(chatMessages: [])
}
