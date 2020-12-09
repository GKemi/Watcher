//
//  TMDbAPIWrapper.swift
//  Watcher
//
//  Created by Gil Hakemi on 09/12/2020.
//

import Foundation
import TMDBSwift
import AuthenticationServices

class TMDbAPIWrapper {
    init() {
        TMDBConfig.apikey = apiKey
    }
    
    func performSignIn() {
        let request = URLRequest(url: authenticationPath)
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data {
                ASWebAuthenticationSession.
            }
        }.resume()
    }
}

//Request a request token
//1. Load the following URL (either in a SFSafari ViewController or ASWebAuthenticationSession): https://www.themoviedb.org/authenticate/{REQUEST_TOKEN}?redirect_to=http://www.yourapp.com/approved
extension TMDbAPIWrapper {
    var baseURL: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        
        return components
    }
    
    var authenticationPath: URL {
        var authenticationURL = baseURL
        authenticationURL.path = "/3/authentication/token/new"
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        authenticationURL.queryItems = [
            apiKeyQuery
        ]
        
        return authenticationURL.url!
    }
}
