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
            
            WidgetFeatureView()
                .tabItem {
                    Label("Widget", systemImage: "photo.on.rectangle.angled")
                }
            
            NotificationFeatureView()
                .tabItem {
                    Label("Notificação", systemImage: "paperplane.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
