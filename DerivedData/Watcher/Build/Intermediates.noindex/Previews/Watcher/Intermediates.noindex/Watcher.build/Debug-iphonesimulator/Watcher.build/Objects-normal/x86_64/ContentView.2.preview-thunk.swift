@_private(sourceFile: "ContentView.swift") import Watcher
import SwiftUI
import SwiftUI

extension ContentView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/hakemg01/Documents/iOS/Watcher/Watcher/ContentView.swift", line: 19)
        AnyView(ContentView())
#sourceLocation()
    }
}

extension ContentView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/hakemg01/Documents/iOS/Watcher/Watcher/ContentView.swift", line: 12)
        AnyView(Text(__designTimeString("#5486.[1].[0].property.[0].[0].arg[0].value.[0].value", fallback: "Hello, world!"))
            .padding())
#sourceLocation()
    }
}

import struct Watcher.ContentView
import struct Watcher.ContentView_Previews