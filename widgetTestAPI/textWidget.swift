//
//  textWidget.swift
//  widgetTestAPIExtension
//
//  Created by Katherine JANG on 3/22/23.
//

import SwiftUI
import Foundation
import WidgetKit

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = widgetTestConstant.appGroupName
        return UserDefaults(suiteName: appGroupId)!
    }
}

struct SimpleEntryy: TimelineEntry {
    let date: Date
    let texts: [String]
}

struct textWidgetProvider: TimelineProvider {
    typealias Entry = SimpleEntryy
    
    func placeholder(in context: Context) -> SimpleEntryy {
       SimpleEntryy(date: Date(), texts: ["randomm"])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntryy) -> Void) {getTexts{ texts in
        let entry = SimpleEntryy(date: Date(), texts: texts)
        completion(entry)
        
    }}
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntryy>) -> Void) { getTexts { texts in
        let currentDate = Date()
        let entry = SimpleEntryy(date: currentDate, texts: texts)
        let nextRefresh = Calendar.current.date(byAdding:.minute, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
        completion(timeline)
    }}
    
    private func getTexts(completion: @escaping ([String]) -> ()) {
        
        var components = URLComponents(string: "https://meowfacts.herokuapp.com")!
        let count = URLQueryItem(name: "count", value: "\(getStorage())")
        components.queryItems = [count]
        let url = components.url!
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data,
                  let textModel = try? JSONDecoder().decode(TextModel.self, from: data) else {return}
            print("textMode: \(textModel)")
            completion(textModel.datas)
        }.resume()
    }
    
    func getStorage() -> Int {
        return UserDefaults.shared.object(forKey: widgetTestConstant.storageKey) as! Int
    }
}


struct textWidget: Widget {
    let kind: String = "com.textWidget.hejang."
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: textWidgetProvider()){ entry in
            textWidgeEntryView(entry: entry)
        }
        .configurationDisplayName("api")
        .description("create Random Text")
    }
}

struct textWidgeEntryView: View {
    
    var entry: textWidgetProvider.Entry
    
    private var randomColor: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    var body: some View {
        ZStack {
            randomColor.opacity(0.6)
            VStack{
                ForEach(entry.texts, id: \.self) { text in
                    LazyVStack {
                        Text(text)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Divider()
                        
                    }
                }
            }
        }
    }
}

struct textWidget_Previews: PreviewProvider {
    static var previews: some View {
        textWidgeEntryView(entry: SimpleEntryy(date: Date(), texts: ["randommm.."]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
