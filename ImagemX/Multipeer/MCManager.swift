//
//  MCManager.swift
//  ImagemX
//
//  Created by Victor Kaue Lima De Paiva on 16/10/25.
//

import Foundation
import MultipeerConnectivity

class MCManager: NSObject, ObservableObject {
    //    static var shared = MCManager()
    let advertiser: MCNearbyServiceAdvertiser
    let browser: MCNearbyServiceBrowser
    let session: MCSession
    
    private let myPeerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let serviceType = "imagemx-mpc"
    
    @Published private(set) var connectedDevices: Set<MCPeerID> = []
    @Published private(set) var availableDevices: Set<MCPeerID> = []
    
    
    override init(){
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.myPeerID, discoveryInfo: nil, serviceType: self.serviceType)
        self.browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        self.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        super.init()
        self.advertiser.delegate = self //TODO: Por que utilizar self e delegate? só funciona com os protocolos de delegate
        self.browser.delegate = self
        self.session.delegate = self

    }
}

extension MCManager: MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
    
    
}

extension MCManager: MCNearbyServiceBrowserDelegate{
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            self.availableDevices.insert(peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availableDevices.remove(peerID)
        }
    }
    
    
}

extension MCManager: MCSessionDelegate{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        <#code#>
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        <#code#>
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        <#code#>
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        <#code#>
    }
    
    
}
