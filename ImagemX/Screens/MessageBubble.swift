//
//  MessageBubble.swift
//  ImagemX
//
//  Created by João Felipe Schwaab on 17/10/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            if message.image != nil {
                Image("WhatsApp Image 2025-10-17 at 17.49.17")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
            } else {
                Text(message.text)
                    .padding(10)
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundStyle(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                    .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
            }
            if !message.isUser {
                Spacer()
            }
        }
    }
}

#Preview {
    var testMessage: Message = Message(text: "TESTE", isUser: false, image: Image("WhatsApp Image 2025-10-17 at 17.49.17"))
    MessageBubble(message: testMessage)
}
