//
//  Candidate.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import Foundation

struct Candidate: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String?
    var linkedinURL: String?
    var note: String?
    var isFavorite: Bool
    var fullName: String {
        firstName + " " + lastName.prefix(1).capitalized + "."
    }
    
    enum CodingKeys: CodingKey {
        case id, firstName, lastName, email, phone, linkedinURL, note, isFavorite
    }
    
    init(id: String = UUID().uuidString, firstName: String = "", lastName: String = "", email: String = "", phone: String? = nil, linkedinURL: String? = nil, note: String? = nil, isFavorite: Bool = false) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.linkedinURL = linkedinURL
        self.note = note
        self.isFavorite = isFavorite
    }
    
}
