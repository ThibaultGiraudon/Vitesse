//
//  API+Error.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

extension API {
    /// Represents different types of API errors.
    enum Error: Swift.Error, LocalizedError, Hashable {
        /// The request is malformed.
        case malformed
        /// The request failed due to invalid credentials.
        case badRequest
        /// The request is not authorized.
        case unauthorized
        /// The requested resource was not found.
        case notFound
        /// An error occurred while processing the response.
        case responseError
        /// A server-side error occurred.
        case internalServerError
        /// A custom error with a specific reason.
        case custom(reason: String)
        
        /// Provides a human-readable description of the error.
        var errorDescription: String? {
            switch self {
                case .malformed:
                    "The request is malformed."
                case .badRequest:
                    "Failed to log in (bad username and/or password)."
                case .unauthorized:
                    "Unauthorized request."
                case .notFound:
                    "Page or resource not found."
                case .responseError:
                    "An error occurred while processing the response."
                case .internalServerError:
                    "We are encountering a problem with our server. Please try again later."
                case .custom(let reason):
                    reason
            }
        }
    }
    
    /// Represents an error response from the API.
    struct APIError: Codable {
        /// The reason for the error.
        let reason: String
        /// Indicates whether an error occurred.
        let error: Bool
    }
}
