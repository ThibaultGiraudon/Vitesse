//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import Foundation

class CandidateViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var editedCandidate: Candidate
    @Published var showAlert = false
    @Published var alertTitle = ""
    var shouldDisable: Bool {
        editedCandidate.firstName.isEmpty || editedCandidate.lastName.isEmpty || editedCandidate.email.isEmpty || editedCandidate.phone == nil
    }
    @Published var transferedMessage = ""
    let api: APIProtocol
    
    init(candidate: Candidate, api: APIProtocol = API.shared) {
        self.candidate = candidate
        self.editedCandidate = candidate
        self.api = api
    }
    
    @MainActor
    func setFavorite() async {
        do {
            candidate = try await api.call(endPoint: API.CandidatesEndPoints.favorite(id: candidate.id))
        } catch {
            alertTitle = error.localizedDescription
            showAlert = true
        }
    }
    
    @MainActor
    func updateCandidate() async {
        do {
            transferedMessage = ""
            
            guard editedCandidate.email.isValidEmail else {
                transferedMessage = "Invalid email format."
                return
            }
            
            guard editedCandidate.phone != nil else {
                transferedMessage = "Phone number is required."
                return
            }
            
            guard editedCandidate.phone!.isValidPhone else {
                transferedMessage = "Invalid phone number format."
                return
            }
            
            candidate = try await api.call(endPoint: API.CandidatesEndPoints.update(candidate: editedCandidate)) as Candidate
        } catch {
            alertTitle = error.localizedDescription
            showAlert = true
        }
    }
    
}
