//
//  ImagemWidget.swift
//  ImagemWidget
//
//  Created by Pedro Santos on 20/10/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }


    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ImagemWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("ImageX")
                .resizable()
                .scaledToFill()
                .blur(radius: 15.0)
        }
        .widgetURL(URL(string: "imagemx://show-image"))
    }
}


@main
struct ImagemWidget: Widget {
    let kind: String = "ImagemWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ImagemWidgetEntryView(entry: entry)
                .containerBackground(.fill.secondary, for: .widget)
        }
        .configurationDisplayName("Imagem Borrada")
        .description("Um widget que mostra uma imagem com desfoque.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
