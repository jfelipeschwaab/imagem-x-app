//
//  ContentView.swift
//  ImagemX
//
//  Created by João Felipe Schwaab on 16/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
                Button(action: dispararSurpresa) {
                    
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(14)
                        .background(Color.pink)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
            
        }
        .padding()
        .task {
            do {
                let request = try await UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound])
                if request {
                    print("Permissão aprovada")
                } else {
                    print("Permissão negada")
                }
            } catch {
                print("Falha ao pedir solicitação \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}
