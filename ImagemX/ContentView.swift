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
