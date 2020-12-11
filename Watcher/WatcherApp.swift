//
//  WatcherApp.swift
//  Watcher
//
//  Created by Gil Hakemi on 09/12/2020.
//

import SwiftUI
import TMDBSwift

@main
struct WatcherApp: App {
    var body: some Scene {
        WindowGroup {
            let authenticator = TMDbAuthenticator()
            let apiWrapper = TMDbAPIWrapper(authenticator: authenticator)
            MainView(apiWrapper: apiWrapper)
        }
    }
}
