//
//  ContentView.swift
//  ImagemX
//
//  Created by João Felipe Schwaab on 16/10/25.
//

import SwiftUI

struct ContentView: View {

    @State private var showUnblurredImage = false

    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("App Principal")
                .font(.title)
            Text("Toque no widget para ver a imagem nítida.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
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
        .onOpenURL { incomingURL in
            if incomingURL.scheme == "imagemx" && incomingURL.host == "show-image" {
                showUnblurredImage = true
            }
        }
        .sheet(isPresented: $showUnblurredImage) {
            UnblurredImageView()
        }
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

struct UnblurredImageView: View {
    var body: some View {
        ZStack {
            Image("ImageX")
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}


#Preview {
    ContentView()
}