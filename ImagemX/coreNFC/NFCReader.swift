//
//  NFCReader.swift
//  ImagemX
//
//  Created by Paulo Henrique Costa Alves on 16/10/25.
//

import Foundation
import CoreNFC

class NFCReader: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    @Published var tagDetected: Bool = false
    var session: NFCTagReaderSession?
    
    func beginScanning() {
        session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self)
        session?.alertMessage = "Aproxime uma tag NFC"
        session?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Sessão NFC ativa")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]){
        guard let tag = tags.first else { return }
        session.connect(to: tag) { (error) in
            if let error = error {
                print("Falha ao connectar: \(error.localizedDescription)")
                session.invalidate(errorMessage: "Falha ao conectar")
                return
            }
            
            var isCompatible = false
            switch tag {
            case .iso15693(let iso15693):
                print("ISO15693 disponível: \(iso15693.isAvailable)")
                isCompatible = iso15693.isAvailable
                break
            case .feliCa(let feliCa):
                print("feliCa disponível: \(feliCa.isAvailable)")
                isCompatible = feliCa.isAvailable
                break
            case .iso7816(let iso7816):
                print("ISO7816 disponível: \(iso7816.isAvailable)")
                isCompatible = iso7816.isAvailable
                break
            case .miFare(let miFare):
                print("miFare disponível: \(miFare.isAvailable)")
                let family = miFare.mifareFamily
                let compativel = (family == .ultralight || family == .desfire || family == .plus)
                
                print("compactivel: \(compativel)")
                print("Family: \(miFare.mifareFamily)")
                print("Identificador: \(miFare.identifier)")
                
                if !miFare.isAvailable && !compativel {
                    print("MIFARE não compatível. family = \(family) isAvailable = \(miFare.isAvailable)")
                    session.invalidate()
                    return
                }
                isCompatible = miFare.isAvailable
                break
            @unknown default:
                print("Tipo de tag desconhecido")
                isCompatible = tag.isAvailable
                break
            }
            
            DispatchQueue.main.async {
                self.tagDetected = isCompatible
            }
            
            session.alertMessage = "Tag lida"
            session.invalidate()
        }
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("Sessão NFC invalida: \(error.localizedDescription)")
    }
}

