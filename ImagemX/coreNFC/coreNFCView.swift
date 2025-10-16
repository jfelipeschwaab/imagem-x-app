//
//  coreNFCView.swift
//  ImagemX
//
//  Created by Paulo Henrique Costa Alves on 16/10/25.
//

import SwiftUI
import CoreNFC

struct coreNFCView: View {
    var nfcReader: NFCReader = NFCReader()
    
    var body: some View {
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
