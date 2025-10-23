//
//  MCManager.swift
//  ImagemX
//
//  Created by Victor Kaue Lima De Paiva on 16/10/25.
//

import Foundation
import MultipeerConnectivity

class MCManager: NSObject, ObservableObject {
    static var shared = MCManager()
    
    //    static var shared = MCManager()
    let advertiser: MCNearbyServiceAdvertiser
    let browser: MCNearbyServiceBrowser
    let session: MCSession
    
    private let myPeerID: MCPeerID = MCPeerID.unique()
    private let serviceType = "imagemx-mpc"
    
    
    @Published var connectedDevices: Set<MCPeerID> = []
    @Published var availableDevices: Set<MCPeerID> = []
    @Published var receivedPeers: Set<MCPeerID> = [] // Set de dispositivos que já receberam o dado (imagem)
    @Published var receivedImage: UIImage?
    
    override init(){
        self.receivedImage = nil
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.myPeerID, discoveryInfo: nil, serviceType: self.serviceType)
        self.browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        self.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        super.init()
        self.advertiser.delegate = self //TODO: Por que utilizar self e delegate? só funciona com os protocolos de delegate
        self.browser.delegate = self
        self.session.delegate = self
        
    }
}

extension MCManager {
    func send(_ dados: Data? = UIImage(named: "sus")?.pngData()){
        guard let dado = dados else {
            print("Valor inválido")
            return
        }
        
        do{
            let recievedDevices = encode()
            let peersToSend = connectedDevices.subtracting(receivedPeers)
            
            try session.send(dado, toPeers: Array(peersToSend), with: .reliable)
            try session.send(recievedDevices, toPeers: Array(connectedDevices), with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func encode() -> Data {
        let peersName = Set(receivedPeers.map { $0.displayName })
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(peersName)
            return data
        } catch {
            print(error.localizedDescription)
            return Data()
        }
    }
    
    func decode(dado: Data) {
        let decoder = JSONDecoder()
        do{
            let peers = try decoder.decode(Set<String>.self, from: dado)
            let newPeers = peers.map { MCPeerID(displayName: $0) }
            self.receivedPeers.formUnion(newPeers)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startAdvertiser(){
        advertiser.startAdvertisingPeer()
    }
    
    func startBrowser(){
        browser.startBrowsingForPeers()
    }
    
    func stopAdvertiser(){
        advertiser.stopAdvertisingPeer()
    }
    
    func stopBrowser(){
        browser.stopBrowsingForPeers()
    }
    
    func start(){
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func stop(){
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
}

extension MCManager: MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.availableDevices.insert(peerID)
        invitationHandler(true, self.session)
    }
}

extension MCManager: MCNearbyServiceBrowserDelegate{
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if !receivedPeers.contains(peerID) {
            print("Peer encontrado: \(peerID.displayName). Convidando automaticamente")
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 300)
            DispatchQueue.main.async {
                self.availableDevices.remove(peerID)
                print("Peer removido de availableDevices: \(peerID)")
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.connectedDevices.remove(peerID)
            self.availableDevices.remove(peerID)
        }
    }
}

extension MCManager: MCSessionDelegate{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Peer conectado")
            self.connectedDevices.insert(peerID)
        case .connecting:
            print("Peer conectando")
        case .notConnected:
            print("Peer não conectado")
        @unknown default: //'MCSessionState' pode conter valores desconhecidos, possivelmente adicionado nas novas versões; this is an error in the Swift 6 language mode
            fatalError()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let image = UIImage(data: data) {
                self.receivedImage = image
                print("Imagem recebida de \(peerID.displayName)")
            } else {
                self.decode(dado: data)
            }

            if !self.receivedPeers.contains(peerID) {
                self.receivedPeers.insert(peerID)
                self.send()
            }
        }
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
    
}

extension MCPeerID {
    static func unique() -> MCPeerID {
        let defaults = UserDefaults.standard
        if let savedID = defaults.string(forKey: "peer_uuid") {
            return MCPeerID(displayName: savedID)
        } else {
            let newID = UUID().uuidString
            defaults.set(newID, forKey: "peer_uuid")
            return MCPeerID(displayName: newID)
        }
    }
}
