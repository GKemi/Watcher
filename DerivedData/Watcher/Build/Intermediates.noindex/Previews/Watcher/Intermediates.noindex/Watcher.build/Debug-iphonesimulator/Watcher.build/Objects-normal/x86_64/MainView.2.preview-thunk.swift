@_private(sourceFile: "MainView.swift") import Watcher
import SwiftUI
import SwiftUI

extension ContentView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/hakemg01/Documents/iOS/Watcher/Watcher/MainView.swift", line: 19)
        AnyView(MainView())
#sourceLocation()
    }
}

extension MainView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/hakemg01/Documents/iOS/Watcher/Watcher/MainView.swift", line: 12)
        AnyView(Text(__designTimeString("#5547.[1].[0].property.[0].[0].arg[0].value.[0].value", fallback: "Hello, world!"))
            .padding())
#sourceLocation()
    }
}

import struct Watcher.MainView
import struct Watcher.ContentView_Previews