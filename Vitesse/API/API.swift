//
//  API.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

/// Defines the requirements for an URLSession.
protocol URLSessionInterface {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionInterface { }

/// Handles API requests and communication with the server.
class API {
    /// A shared instance of the API for global access.
    static var shared = API()
    /// The URL session used for network requests.
    private var session: URLSessionInterface
    
    /// Initializes the API with a URLSession instance for injection tests.
    init(session: URLSessionInterface = URLSession.shared) {
        self.session = session
    }
    
    /// Sends a request to the given endpoint and decodes the reponse into a specified `Decodable` type.
    ///
    /// - Parameter endPoint: The API endpoint to call.
    /// - Returns: The decoded response of type `T`.
    /// - Throws: An `API.Error` if the request fails or the response in invalid.
    func call<T: Decodable>(endPoint: EndPoint) async throws -> T {
        guard let request = endPoint.request else {
            throw Error.badRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.responseError
        }
        
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            let decoded = try JSONDecoder().decode(APIError.self, from: data)
            switch httpResponse.statusCode {
                case 401:
                    throw Error.custom(reason: decoded.reason)
                case 404:
                    throw Error.notFound
                case 500:
                    throw Error.custom(reason: "This email is already taken.")
                default:
                    throw Error.internalServerError
            }
        }
        if data.isEmpty {
            return EmptyResponse() as! T
        }
        
        let decoded = try JSONDecoder().decode(T.self, from: data)
        
        return decoded
    }
}
