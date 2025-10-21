//
//  ImagemXApp.swift
//  ImagemX
//
//  Created by João Felipe Schwaab on 16/10/25.
//

import SwiftUI

@main
struct ImagemXApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: CustomAppDelegate
    
    @State private var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                ContentView() 
                    
                .navigationDestination(for: String.self) { identifier in
                    if identifier == "surpresa" {
                        SurpresaView()
                    }
                }
            }
            .onAppear {
                 // appDelegate.app = self // Esta linha não é mais necessária
            }
            // 4. Ouve pela notificação interna postada pelo AppDelegate
            .onReceive(NotificationCenter.default.publisher(for: .showSurpresa)) { _ in
                
                // 5. Navega para a SurpresaView
                print("Recebido post .showSurpresa, navegando...")
                
                // Limpa a pilha de navegação (caso já esteja em outra tela)
                navigationPath = NavigationPath()
                
                // Adiciona o identificador "surpresa" ao caminho
                navigationPath.append("surpresa")
            }
        }
    }
}
