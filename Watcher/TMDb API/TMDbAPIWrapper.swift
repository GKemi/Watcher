//
//  TMDbAPIWrapper.swift
//  Watcher
//
//  Created by Gil Hakemi on 09/12/2020.

import Foundation


class TMDbAPIWrapper: ObservableObject {
//    @Published favouriteMovies = [Movie]()
    
    var authenticator: TMDbAuthenticator
    var sessionID: SessionIDResponse?
    
    init(authenticator: TMDbAuthenticator) {
        self.authenticator = authenticator
    }
        
    func performSignIn() {
        authenticator.performSignIn { result in
            switch result {
            case .failure(let error):
                print(error)
                break
            case .success(let sessionID):
                self.sessionID = sessionID
                self.getFavouriteMovies()
                break
            }
        }
    }
    
    func getFavouriteMovies() {
        guard let sessionID = sessionID else {
            print("No sessionID available")
            return
        }
        
        let url = favouriteMoviesURL(with: sessionID.sessionID)
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let favouriteMovies = try? JSONDecoder().decode(FavouriteMovies.self, from: data)
                
                if let favouriteMovies = favouriteMovies {
                    favouriteMovies.results.forEach { print($0.title) }
                }
            }
        }.resume()
    }

}

private extension TMDbAPIWrapper {
    var baseURL: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        
        return components
    }
    
    func favouriteMoviesURL(with sessionID: String) -> URL {
        var favouriteMovies = baseURL
        favouriteMovies.path = "/3/account/0/favorite/movies"
        favouriteMovies.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "session_id", value: sessionID)
        ]
        
        return favouriteMovies.url!
    }
}

struct FavouriteMovies: Codable {
    var results: [Movie]
    let totalPages: Int
    
    struct Movie: Codable {
        let title: String
    }
}

