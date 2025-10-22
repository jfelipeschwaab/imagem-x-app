//
//  ChatViewModel.swift
//  ImagemX
//
//  Created by João Felipe Schwaab on 17/10/25.
//


import SwiftUI
import FoundationModels

struct Message: Identifiable {
    
    var id = UUID()
    var text: String
    let isUser: Bool
    var image : Image?
    
}

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [
        Message(text: "Digite sua pergunta para o Foundations Model", isUser: false),
    ]
    
    @Published var currentString : String = ""
    
    private var session : LanguageModelSession?
    
    init() {
        setupSession()
    }
    
    func sendMessage() async {
        guard !currentString.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newMessage = Message(text: currentString, isUser: true)
        messages.append(newMessage)
        
        await sendPrompt(prompt: currentString)
        
        currentString = ""
        
        //TODO: A função que irá receber a resposta do Foundations Model virá aqui
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.messages.append(Message(text: "Obrigado pela pergunta! tenho apenas uma resposta para você...", isUser: false))

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.messages.append(Message(text: " ", isUser: false, image: Image("WhatsApp Image 2025-10-17 at 17.49.17")))
        }
    }
    
    private func setupSession() {
        self.session = LanguageModelSession()
    }
    
    private func sendPrompt(prompt: String) async {
        guard let session = self.session else { return }
        do {
            let response = try await session.respond(to: prompt)
            let assistantText = response.content
            
            
            let assistentMessage = Message(text: assistantText, isUser: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                print("Resposta gerada: \(assistantText)")
            }
            
        } catch {
            print("ERRO: \(error.localizedDescription)")
        }
    }
    
    
}

