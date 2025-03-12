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
            throw Error.badRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.responseError
        }
        
        guard httpResponse.statusCode == 200 else {
            let decoded = try JSONDecoder().decode(APIError.self, from: data)
            switch httpResponse.statusCode {
                case 401:
                    throw Error.custom(reason: decoded.reason)
                case 404:
                    throw Error.notFound
                case 500:
                    throw API.Error.uniqueConstraint
                default:
                    throw Error.internalServerError
            }
        }
        
        let decoded = try JSONDecoder().decode(T.self, from: data)
        
        return decoded
    }

    func call(endPoint: EndPoint) async throws {
        guard let request = endPoint.request else {
            throw Error.badRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.responseError
        }
        
        guard httpResponse.statusCode == 200 else {
            print(httpResponse.statusCode)
            let decoded = try JSONDecoder().decode(APIError.self, from: data)
            switch httpResponse.statusCode {
                case 401:
                    throw Error.custom(reason: decoded.reason)
                case 404:
                    throw Error.notFound
                case 500:
                    throw API.Error.uniqueConstraint
                default:
                    throw Error.internalServerError
            }
        }
    }
}
