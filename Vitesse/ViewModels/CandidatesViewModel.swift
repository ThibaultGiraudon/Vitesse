//
//  CandidatesViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import Foundation

/// ViewModel managing candidates-related operations.
@MainActor
class CandidatesViewModel: ObservableObject {
    /// List of all candidates
    @Published var candidates: [Candidate] = []
    
    @Published var selectedCandidates: [Candidate] = []
        
    /// Handles error.
    @Published var alertTitle = ""
    @Published var showAlert = false
    @Published var showAlertSheet = false
    @Published var transferedMessage = ""
    
    /// Handles filtering candidates.
    @Published var searchText = ""
    @Published var showFavorites = false
    
    /// Filtered list of candidates based on search criteria and favorite ststaus
    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            let matchesSearch = searchText.isEmpty || candidate.firstName.contains(searchText) || candidate.lastName.contains(searchText)
            let matchesFav = !showFavorites || candidate.isFavorite
            return matchesSearch && matchesFav
        }
    }
    
    /// API instance used for authentication requests.
    let api: API
    
    /// Initializes the candidates ViewModel with an API instance for injection tests.
    init(session: URLSessionInterface = URLSession.shared) {
        self.api = API(session: session)
    }
    
    /// Fetches the list of candidates.
    func fetchCandidates() async {
        transferedMessage = ""
        alertTitle = ""
        do {
            candidates = try await api.call(endPoint: API.CandidatesEndPoints.candidates)
            
        } catch {
            alertTitle = error.localizedDescription
            showAlert = true
        }
    }
    
    /// Creates a new candidate.
    /// - Performs validation checks before sending request.
    /// - Adds the created candidate to the list upon success.
    func createCandidate(_ candidate: Candidate) async {
        transferedMessage = ""
        alertTitle = ""
        guard let phone = candidate.phone else {
            transferedMessage = "The phone number is required"
            return
        }
        
        if !candidate.email.isValidEmail{
            transferedMessage = "Invalid email format"
            return
        }
        
        if !phone.isValidPhone {
            transferedMessage = "Invalid phone number format"
            return
        }
        
        do {
            let newCandidate: Candidate = try await api.call(endPoint: API.CandidatesEndPoints.create(candidate: candidate))
            candidates.append(newCandidate)
        } catch {
            alertTitle = error.localizedDescription
            showAlertSheet = true
        }
    }
    
    /// Deletes a list of selected candidates.
    /// - Iterates over the selections and removes them from the API and local list.
    func deleteCandidates() async {
        transferedMessage = ""
        alertTitle = ""
        for candidate in selectedCandidates {
            guard candidates.contains(where: {$0.id == candidate.id}) else {
                print("cant find \(candidate.firstName)")
                return
            }
            do {
                let _ = try await api.call(endPoint: API.CandidatesEndPoints.delete(id: candidate.id)) as EmptyResponse
                candidates.removeAll(where: { $0.id == candidate.id })
                selectedCandidates = []
            } catch {
                alertTitle = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    /// Deletes a candidates by its index in the list.
    /// - Conform to `onDelete` modifier.
    /// - Removes the candidate from the API and local list.
    func deleteCandidate(at index: IndexSet) async {
        transferedMessage = ""
        alertTitle = ""
        for candidateIndex in index {
            do {
                let _ = try await api.call(endPoint: API.CandidatesEndPoints.delete(id: candidates[candidateIndex].id)) as EmptyResponse
                candidates.removeAll(where: { $0.id == candidates[candidateIndex].id })
            } catch {
                alertTitle = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    /// Toggles the favorite status of a candidate.
    /// - Updates the candidate in the API and local list.
    func setFavorite(for candidate: Candidate) async {
        transferedMessage = ""
        alertTitle = ""
        do {
            let reponse = try await api.call(endPoint: API.CandidatesEndPoints.favorite(id: candidate.id)) as Candidate
            guard let index = candidates.firstIndex(where: {$0.id == reponse.id}) else {
                return
            }
            
            candidates[index] = reponse
            
        } catch {
            alertTitle = error.localizedDescription
            showAlert = true
        }
    }    
}
