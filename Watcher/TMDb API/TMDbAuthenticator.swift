//
//  TMDbAuthenticator.swift
//  Watcher
//
//  Created by Gil Hakemi on 09/12/2020.
//

import Foundation
import Combine
import AuthenticationServices


class TMDbAuthenticator: NSObject {
    var subscriptions = Set<AnyCancellable>()
    var signInResult: ((Result<SessionIDResponse, Error>) -> ())?
    
    func performSignIn(signInResult: @escaping (Result<SessionIDResponse, Error>) -> ()) {
        self.signInResult = signInResult
        let request = URLRequest(url: requestTokenPath)
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data {
                let requestToken = try? JSONDecoder().decode(RequestTokenResponse.self, from: data)
                self.signIn(requestToken: requestToken?.token ?? "")
            }
        }.resume()
    }
    
    func signIn(requestToken: String) {
        let signInPromise = Future<Void, Error> { completion in
            let authUrl = self.authenticationURL(with: requestToken)

            let authSession = ASWebAuthenticationSession(
                url: authUrl,
                callbackURLScheme: "hackemi://hackemi.co.uk") { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if url != nil {
                        completion(.success(()))
                    }
            }

            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = true
            authSession.start()
        }

        signInPromise.sink { (completion) in
            switch completion {
            case .failure(let error):
                self.signInResult?(.failure(error))
            default: break
            }
        } receiveValue: { _ in
            self.requestSessionID(with: requestToken)
        }
        .store(in: &subscriptions)
    }
    
    func requestSessionID(with requestToken: String) {
        var request = URLRequest(url: sessionIDUrl())
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody = try! JSONEncoder().encode(RequestTokenResponse(token: requestToken))
        request.httpBody = requestBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let sessionIDResponse = try! JSONDecoder().decode(SessionIDResponse.self, from: data)
                self.signInResult?(.success(sessionIDResponse))
//                self.getAccountDetails(with: sessionIDResponse.sessionID)
            }
        }.resume()
    }
    
    func getAccountDetails(with sessionID: String) {
        let url = accountDetailsURL(sessionID: sessionID)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let accountDetails = try! JSONDecoder().decode(AccountDetails.self, from: data)
                
//                self.signInResult?(.success(accountDetails))
            }
        }.resume()
    }
}

extension TMDbAuthenticator: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

extension TMDbAuthenticator {
    var baseAuthURL: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "themoviedb.org"
        
        return components
    }
    
    var baseURL: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        
        return components
    }
    
    var requestTokenPath: URL {
        var authenticationURL = baseURL
        authenticationURL.path = "/3/authentication/token/new"
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        authenticationURL.queryItems = [
            apiKeyQuery
        ]
        
        return authenticationURL.url!
    }
    
    func authenticationURL(with requestToken: String) -> URL {
        var authenticationURL = baseAuthURL
        authenticationURL.path = "/authenticate/\(requestToken)"
        let callbackURI = URLQueryItem(name: "redirect_to", value: "hackemi://hackemi.co.uk")
        authenticationURL.queryItems = [
            callbackURI
        ]
        
        return authenticationURL.url!
    }
    
    func sessionIDUrl() -> URL {
        var sessionID = baseURL
        sessionID.path = "/3/authentication/session/new"
        sessionID.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        return sessionID.url!
    }
    
    func accountDetailsURL(sessionID: String) -> URL {
        var accountDetails = baseURL
        accountDetails.path = "/3/account"
        accountDetails.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "session_id", value: sessionID)
        ]
        
        return accountDetails.url!
    }
}

struct RequestTokenResponse: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "request_token"
    }
}

struct SessionIDResponse: Codable {
    let success: Bool
    let sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case sessionID = "session_id"
    }
}

struct AccountDetails: Codable {
    let id: Int
    let username: String
}
