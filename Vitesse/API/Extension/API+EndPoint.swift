//
//  API+EndPoint.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

extension API {
    protocol EndPoint {
        var path: String { get }
        var authorization: Authorization { get }
        var method: Method { get }
        var body: Data? { get }
        var request: URLRequest? { get }
    }
    
    enum Authorization {
        case none
        case user
    }
    
    enum Method: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
    }
}
