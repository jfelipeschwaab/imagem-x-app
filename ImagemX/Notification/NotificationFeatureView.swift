//
//  NotificationFeatureView.swift
//  ImagemX
//
//  Created by Pedro Santos on 21/10/25.
//

import SwiftUI

struct NotificationFeatureView: View {

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Notificações Push")
                .font(.title)
            Text("Clique no botão para disparar uma notificação.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // 1. O botão foi movido para cá
            Button(action: dispararSurpresa) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(14)
                    .background(Color.pink)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            .padding(.top, 10)
            
        }
        .padding()
        // 2. A tarefa de permissão foi movida para cá
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
    NotificationFeatureView()
}
