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
            }
            .onReceive(NotificationCenter.default.publisher(for: .showSurpresa)) { _ in
                
                print("Recebido post .showSurpresa, navegando...")
                
                navigationPath = NavigationPath()
                
                navigationPath.append("surpresa")
            }
        }
    }
}
