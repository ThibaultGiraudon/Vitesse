//
//  APIFake.swift
//  VitesseTests
//
//  Created by Thibault Giraudon on 26/03/2025.
//

import Foundation
@testable import Vitesse

class APIFake: APIProtocol {
    var shouldSucceed = true
    var data = Data()
    var error: Error = URLError(.badServerResponse)
    
    func call<T: Decodable>(endPoint: API.EndPoint) async throws -> T {
        if shouldSucceed {
            return try JSONDecoder().decode(T.self, from: data)
        }
        throw error
    }
    
    func call(endPoint: API.EndPoint) async throws {
        if !shouldSucceed {
            throw error
        }
    }
    
}
