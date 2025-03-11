//
//  EditViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import Foundation

class EditViewModel: ObservableObject {
    private var id: String
    @Published var email: String
    @Published var phone: String
    @Published var linkedinURL: String
    @Published var note: String
    @Published var firstName: String
    @Published var lastName: String
    var title: String {
        firstName + " " + lastName.prefix(1) + "."
    }
    var completion: (Candidate) -> ()
    
    init(candidate: Candidate, completion: @escaping (Candidate) -> ()) {
        self.id = candidate.id
        self.email = candidate.email
        self.phone = candidate.phone ?? ""
        self.linkedinURL = candidate.linkedinURL ?? ""
        self.note = candidate.note ?? ""
        self.firstName = candidate.firstName
        self.lastName = candidate.lastName
        self.completion = completion
    }
    
    func updateCandidate() async {
        do {
            let candidate = try await API.shared.call(endPoint: API.CandidatesEndPoints.update(candidate: self.createCandidate())) as Candidate
            
            completion(candidate)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createCandidate() -> Candidate {
        return Candidate(phone: phone, note: note.isEmpty ? nil : note, id: id, firstName: firstName, linkedinURL: linkedinURL.isEmpty ? nil : linkedinURL, isFavorite: false, email: email, lastName: lastName)
    }
    
}
