//  SurpresaView.swift
//  ImagemX
//
//  Criado por Pedro Santos em 21/10/25.
//

import SwiftUI

struct SurpresaView: View {
    var body: some View {
        VStack {
            Image("ImageX")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            
            Text("SURPRESA!")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .navigationTitle("A Surpresa")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SurpresaView()
    }
}
