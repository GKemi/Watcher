//
//  ContentView.swift
//  Watcher
//
//  Created by Gil Hakemi on 09/12/2020.
//

import SwiftUI

struct MainView: View {
    var apiWrapper: TMDbAPIWrapper
    
    
    var body: some View {
        HStack {
            Button(action: { apiWrapper.performSignIn() }) { Text("Sign in") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let apiWrapper = TMDbAPIWrapper()
        MainView(apiWrapper: apiWrapper)
    }
}
