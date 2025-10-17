//
//  FoundationsModelView.swift
//  ImagemX
//
//  Created by João Felipe Schwaab on 16/10/25.
//

import SwiftUI

struct Message: Identifiable {
    
    var id = UUID()
    var text: String
    let isUser: Bool
    
}


struct FoundationsModelView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FoundationsModelView()
}
