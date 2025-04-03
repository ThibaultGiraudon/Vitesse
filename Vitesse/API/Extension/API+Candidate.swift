//
//  API+Candidate.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import Foundation

extension API {
    /// Defines the available endpoints for candidate-related operations.
    enum CandidatesEndPoints: EndPoint {
        /// Retrieves a specific candidate by ID or lists of all candidates if `id` is not provided.
        case candidate(id: String?)
        /// Creates a new candidate.
        case createCandidate(candidate: Candidate)
        /// Deletes a candidate by id.
        case delete(id: String)
        /// Marks a candidate as favorite or not by id.
        case favorite(id: String)
        /// Update a candidate.
        case update(candidate: Candidate)
        
        var path: String {
            switch self {
                case .candidate(let id):
                    if let id = id {
                        return "/candidate/\(id)"
                    }
                    return "/candidate/"
                case .createCandidate:
                    return "/candidate/"
                case .delete(let id):
                    return "/candidate/\(id)/"
                case .favorite(let id):
                    return "/candidate/\(id)/favorite"
                case .update(let candidate):
                    return "/candidate/\(candidate.id)/"
            }
        }

        var authorization: API.Authorization { .user }

        var method: API.Method {
            switch self {
                case .candidate:
                    .get
                case .createCandidate:
                    .post
                case .delete:
                    .delete
                case .favorite:
                    .post
                case .update:
                    .put
            }
        }
        
        var body: Data? {
            switch self {
                case .candidate, .delete, .favorite:
                    return nil
                case .createCandidate(let candidate), .update(let candidate):
                    let data = ["email": candidate.email, "note": candidate.note, "linkedinURL": candidate.linkedinURL, "firstName": candidate.firstName, "lastName": candidate.lastName, "phone": candidate.phone]
                    return try? JSONSerialization.data(withJSONObject: data)
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
            if let body = body {
                request.httpBody = body
            }
            request.httpMethod = method.rawValue
            if authorization == .user {
                request.addValue("Bearer \(User.shared.token)", forHTTPHeaderField: "Authorization")
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return request
        }
  

    }
}
