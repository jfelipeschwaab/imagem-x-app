//
//  ContentView.swift
//  ImagemX
//
//  Created by Pedro Santo on 21/10/25.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            Tab("widget", systemImage: "widget.small") {
                WidgetFeatureView()
            }
            Tab ("Notification", systemImage: "bell.fill") {
                NotificationFeatureView()
            }
            Tab ("CoreNFC", systemImage: "cpu.fill") {
                coreNFCView()
            }
            Tab ("Core Bluetooth", systemImage: "point.3.filled.connected.trianglepath.dotted") {
                CoreBluetoothView()
            }
            Tab ("Foundations", systemImage: "text.page.fill") {
                FoundationsModelView()
            }
            Tab ("Multipeer", systemImage: "iphone.gen2") {
                SharePhotoView()
            }
        }
    }
}

#Preview {
    ContentView()
}
