//
//  ChatMessageView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 29/03/2568.
//

import SwiftUI

enum ChatMessageDirection {
    case left
    case right
}

struct ChatMessageView: View {
    let chatMessage: ChatMessage
    let direction: ChatMessageDirection
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(chatMessage.displayName)
                    .font(.caption)
                    .foregroundStyle(.black)
                
                Text(chatMessage.text)
                
                Text(chatMessage.dateCreated, format: .dateTime)
                    .font(.caption)
                    .opacity(0.4)
                    .frame(maxWidth: 200, alignment: .trailing)
            }
            .padding(8)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 10))
        }
        .overlay(alignment: direction == .left ? .bottomLeading : .bottomTrailing) {
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.title)
                .rotationEffect(.degrees(direction == .left ? 45 : -45))
                .offset(x: direction == .left ? 30 : -30, y: 10)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    ChatMessageView(chatMessage: ChatMessage(text: "Hello World!", uid: UUID().uuidString, displayName: "Joey"), direction: .left, color: .green)
}
