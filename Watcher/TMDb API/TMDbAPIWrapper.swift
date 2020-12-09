//
//  TMDbAPIWrapper.swift
//  Watcher
//
//  Created by Gil Hakemi on 09/12/2020.
//

import Foundation
import TMDBSwift


class TMDbAPIWrapper {
    init() {
        TMDBConfig.apikey = apiKey
    }
    
    func performSignIn() {
        let request = URLRequest(url: authenticationPath)
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data {
                print(String(data: data, encoding: .utf8))
            }
        }.resume()
    }
}

//Request a request token
//1. Perform an API request to: https://api.themoviedb.org/3/authentication/token/new?api_key=<<api_key>>

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
