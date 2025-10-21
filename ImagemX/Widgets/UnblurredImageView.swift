//
//  UnblurredImageView.swift
//  ImagemX
//
//  Created by Pedro Santos on 21/10/25.
//

import SwiftUI

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
    UnblurredImageView()
}
