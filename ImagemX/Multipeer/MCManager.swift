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
    
    private let myPeerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let serviceType = "imagemx-mpc"
    
    
    @Published var connectedDevices: Set<MCPeerID> = []
    @Published var availableDevices: Set<MCPeerID> = []
    
    
    override init(){
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.myPeerID, discoveryInfo: nil, serviceType: self.serviceType)
        self.browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        self.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        super.init()
        self.advertiser.delegate = self //TODO: Por que utilizar self e delegate? só funciona com os protocolos de delegate
        self.browser.delegate = self
        self.session.delegate = self

    }
    
    func start(){
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func stop(){
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    func send(){
        
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
        print("Peer encontrado: \(peerID.displayName). Convidando automaticamente")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 800)
        DispatchQueue.main.async {
            self.connectedDevices.insert(peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.connectedDevices.remove(peerID)
        }
    }
    
    
}

extension MCManager: MCSessionDelegate{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Peer conectado")
        case .connecting:
            print("Peer conectando")
        case .notConnected:
            print("Peer não conectado")
        @unknown default: //'MCSessionState' pode conter valores desconhecidos, possivelmente adicionado nas novas versões; this is an error in the Swift 6 language mode
            fatalError()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
    
    
}
