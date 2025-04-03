//
//  API+EndPoint.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

extension API {
    /// Defines the requirement for an API endpoint.
    protocol EndPoint {
        var path: String { get }
        var authorization: Authorization { get }
        var method: Method { get }
        var body: Data? { get }
        var request: URLRequest? { get }
    }
    
    /// Represents different types of authorization for API request.
    enum Authorization {
        case none
        case user
    }
    
    /// Defines the supported HTTP methods.
    enum Method: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
}
