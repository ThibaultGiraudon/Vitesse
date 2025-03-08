//
//  API.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

class API {
    @Published var token = ""
    static var shared = API()
    private var session: URLSession
    private var error = URLError(.badURL)
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
    
    func call<T: Decodable>(endPoint: EndPoint) async throws -> T {
        guard let request = endPoint.request else {
            print("request")
             throw error
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("response")
            throw error
        }
        
        guard httpResponse.statusCode == 200 else {
            print(httpResponse.statusCode)
            throw error
        }
        
        let decoded = try JSONDecoder().decode(T.self, from: data)
        
        return decoded
    }

    func call(endPoint: EndPoint) async throws {
        guard let request = endPoint.request else {
            print("request")
             throw error
        }
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("response")
            throw error
        }
        
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            switch httpResponse.statusCode {
                case 500:
                    throw API.Error.uniqueConstraint
                default:
                    throw error
            }
        }
    }
}
