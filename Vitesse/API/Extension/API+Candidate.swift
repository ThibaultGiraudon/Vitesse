//
//  API+Candidate.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import Foundation

extension API {
    enum CandidatesEndPoints: EndPoint {
        case candidate(id: String?)
        case createCandidate(email: String, note: String?, linkedinURL: String?, firstName: String, lastName: String, phone: String)
        case delete(id: String)
        
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
                    return "/candidate/\(id)"
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
            }
        }
        
        var body: Data? {
            switch self {
                case .candidate:
                    return nil
                case .createCandidate(let email, let note, let linkedinURL, let firstName, let lastName, let phone):
                    let data = ["email": email, "note": note, "linkedinURL": linkedinURL, "firstName": firstName, "lastName": lastName, "phone": phone]
                    return try? JSONSerialization.data(withJSONObject: data)
                case .delete:
                    return nil
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
            request.addValue("Bearer \(User.shared.token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return request
        }
        
        
    }
}
