//
//  coreNFCView.swift
//  ImagemX
//
//  Created by Paulo Henrique Costa Alves on 16/10/25.
//

import SwiftUI
import CoreNFC

struct coreNFCView: View {
    @StateObject var nfcReader: NFCReader = NFCReader()
    
    var body: some View {
        
        if (nfcReader.tagDetected) {
            Image("monke")
                .resizable()
        }
        
        Button("NFC") {
            nfcReader.beginScanning()
        }
        .buttonStyle(.bordered)
        .padding()
    }
}

#Preview {
    coreNFCView()
}
