//
//  WatcherApp.swift
//  Watcher
//
//  Created by Gil Hakemi on 09/12/2020.
//

import SwiftUI

@main
struct WatcherApp: App {
    var body: some Scene {
        WindowGroup {
            let apiWrapper = TMDbAPIWrapper()
            MainView(apiWrapper: apiWrapper)
        }
    }
}
