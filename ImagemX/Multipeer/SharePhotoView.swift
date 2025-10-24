//
//  SharePhotoView.swift
//  ImagemX
//
//  Created by Victor Kaue Lima De Paiva on 17/10/25.
//

import SwiftUI

struct SharePhotoView: View {
    @StateObject var multipeerManager = MCManager.shared
    var body: some View {
        VStack{
            List{
                Text("Dispositivos")
                    .font(.title)
                Section{
                    Text("Available Devices")
                    ForEach(Array(multipeerManager.availableDevices).sorted(by: { $0.displayName < $1.displayName }), id: \.self) { peer in
                        Text(peer.displayName)
                    }
                }
                Section{
                    Text("Connected Devices")
                    ForEach(Array(multipeerManager.connectedDevices).sorted(by: {$0.displayName < $1.displayName }), id: \.self) { peer in
                        Text(peer.displayName)
                    }
                    
                    Button{
                        multipeerManager.send()
                    } label: {
                        Rectangle()
                    }
                    if let image = multipeerManager.receivedImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 200, height: 300)
                    }
                }
            }
        }
        .onAppear{
            multipeerManager.start()
        }
        .onDisappear(){
            multipeerManager.stop()
        }
    }
    
}

#Preview {
    SharePhotoView()
}
