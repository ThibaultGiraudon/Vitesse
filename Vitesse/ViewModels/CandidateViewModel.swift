//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import Foundation

/// ViewModel managing a single candidate's details and updates.
@MainActor
class CandidateViewModel: ObservableObject {
    /// The current candidate being viewed or edited.
    @Published var candidate: Candidate
    /// A copy of the candidate used for editing before saving changes.
    @Published var editedCandidate: Candidate

    /// Handles error.
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var transferedMessage = ""
    
    /// Determines if the saving button should be disabled.
    var shouldDisable: Bool {
        editedCandidate.firstName.isEmpty || editedCandidate.lastName.isEmpty || editedCandidate.email.isEmpty || editedCandidate.phone == nil
    }
    
    /// API instance used for authentication requests.
    let api: API
    
    /// Initializes the candidate ViewModel.
    /// - Parameters:
    ///   - candidate: The candidate to be displayed and edited.
    ///   - api: An API instance for injection tests.
    init(candidate: Candidate, session: URLSessionInterface = URLSession.shared) {
        self.candidate = candidate
        self.editedCandidate = candidate
        self.api = API(session: session)
    }
    
    /// Toggles the favorite status of a candidate.
    /// - Updates the `candidate` property.
    /// - Updates the candidate in the API.
    func setFavorite() async {
        transferedMessage = ""
        alertTitle = ""
        do {
            candidate = try await api.call(endPoint: API.CandidatesEndPoints.favorite(id: candidate.id))
        } catch {
            alertTitle = error.localizedDescription
            showAlert = true
        }
    }
    
    /// Updates the candidate's information after validating the input fields.
    func updateCandidate() async {
        do {
            transferedMessage = ""
            alertTitle = ""
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
