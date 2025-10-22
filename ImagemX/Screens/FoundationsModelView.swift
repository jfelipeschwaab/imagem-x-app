//
//  FoundationsModelView.swift
//  ImagemX
//
//  Created by João Felipe Schwaab on 16/10/25.
//

import SwiftUI
import FoundationModels


struct FoundationsModelView: View {
    @StateObject private var viewModel : ChatViewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            Text("Foundations Model")
                .font(.title)
                .bold()
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ , _ in
                    if let lastID = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }
            Divider()
            HStack {
                TextField("Digite sua mensagem...", text: $viewModel.currentString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    Task { @MainActor in
                        await viewModel.sendMessage()
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(Color.blue)
                }
            }
            .padding()
        }
    }
}

#Preview {
    FoundationsModelView()
}
