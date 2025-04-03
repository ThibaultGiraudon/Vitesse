//
//  API+Auth.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

extension API {
    /// Defines the available endpoints for authentication-related operations.
    enum AuthEndPoints: EndPoint {
        /// Authenticates user.
        case auth(email: String, password: String)
        /// Register user.
        case register(email: String, password: String, firstName: String, lastName: String)
        
        var path: String {
            switch self {
                case .auth:
                    "/user/auth/"
                case .register:
                    "/user/register/"
            }
        }
        
        var authorization: API.Authorization { .none }
        
        var method: API.Method {
            switch self {
                case .auth:
                    .post
                case .register:
                        .post
            }
        }
        
        var body: Data? {
            switch self {
                case .auth(let email, let password):
                    return try? JSONSerialization.data(withJSONObject: ["email": email, "password": password])
                case .register(let email, let password, let firstName, let lastName):
                    let json = ["email": email, "password": password, "firstName": firstName, "lastName": lastName]
                    return try? JSONSerialization.data(withJSONObject: json)
                    
            }
        }
        
        var request: URLRequest? {
            var components = URLComponents()
            components.scheme = Constants.scheme
            components.host = Constants.host
            components.port = Constants.port
            components.path = path
            
            guard let url = components.url else {
                return nil
            }
            var request = URLRequest(url: url)
            request.httpBody = body
            request.httpMethod = method.rawValue
            if authorization == .user {
                request.addValue("Bearer \(User.shared.token)", forHTTPHeaderField: "Authorization")
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }
        
        
    }
}
