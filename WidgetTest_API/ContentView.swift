//
//  ContentView.swift
//  WidgetTest_API
//
//  Created by Katherine JANG on 3/22/23.
//

import SwiftUI

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = widgetTestConstant.appGroupName
        return UserDefaults(suiteName: appGroupId)!
    }
}

struct ContentView: View {
    @AppStorage(widgetTestConstant.storageKey, store: UserDefaults(suiteName: widgetTestConstant.appGroupName)) private var testStorage: Int = 0
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button(action: {
                testStorage += 1
                UserDefaults.shared.setValue(testStorage, forKey: widgetTestConstant.storageKey)
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(.purple)
                    Text("Do Not Press")
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 100)
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
