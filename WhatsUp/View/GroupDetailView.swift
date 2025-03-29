//
//  GroupDetailView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI
import FirebaseAuth

struct GroupDetailView: View {
    let group: Group
    
    @State private var chatText: String = ""
    
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    ChatMessagesListView(chatMessages: model.chatMessages)
                        .onChange(of: model.chatMessages) { _, _ in
                            if !model.chatMessages.isEmpty {
                                let lastChatMessage = model.chatMessages[model.chatMessages.endIndex - 1]
                                
                                withAnimation {
                                    proxy.scrollTo(lastChatMessage.id, anchor: .bottom)
                                }
                            }
                        }
                }
                
                SendMessageView(chatText: $chatText, action: sendMessage)
            }
            .navigationTitle("\(group.subject) - Chats")
        }
        .onAppear {
            model.listenForChatMessages(in: group)
        }
        .onDisappear {
            model.detachFirestoreChatMessageListener()
        }
    }
    
    private func sendMessage() async  {
        guard let currentUser = appState.userSession else { return }
        let chatMessage = ChatMessage(text: chatText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest")
        do {
            try await model.saveChatMessageToGroup(chatMessage: chatMessage, group: group)
        } catch {
            print("Error send message: \(error.localizedDescription)")
        }
    }
}

#Preview {
    GroupDetailView(group: Group(subject: "Family"))
        .environmentObject(Model())
        .environmentObject(AppState())
}

struct SendMessageView: View {
    @Binding var chatText: String
    let action: () async -> Void
    
    var body: some View {
        HStack {
            TextField("Enter message", text: $chatText, axis: .vertical)
                .foregroundColor(Color.blue)
                .frame(height: 80)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            Button {
                Task {
                    await action()
                    chatText = ""
                }
            } label: {
                Image(systemName: "paperplane")
                    .imageScale(.large)
            }
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal)
        .padding(.bottom)
    }
}
