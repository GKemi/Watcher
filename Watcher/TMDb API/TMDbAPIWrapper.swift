//
//  TMDbAPIWrapper.swift
//  Watcher
//
//  Created by Gil Hakemi on 09/12/2020.

import Foundation


class TMDbAPIWrapper: ObservableObject {
//    @Published favouriteMovies = [Movie]()
    
    var authenticator: TMDbAuthenticator
    var account: AccountDetails?
    
    init(authenticator: TMDbAuthenticator) {
        self.authenticator = authenticator
    }
        
    func performSignIn() {
        authenticator.performSignIn { result in
            switch result {
            case .failure(let error):
                print(error)
                break
            case .success(let account):
                self.account = account
                print("Account details got returned!")
                break
            }
        }
    }
    
    func getFavouriteMovies(_ sessionID: String, _ accountID: Int) {
        
    }

}

private extension TMDbAPIWrapper {
    var baseURL: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        
        return components
    }
    
    func favouriteMoviesURL() {
        var favouriteMovies = baseURL
        favouriteMovies.path = ""
    }
}
