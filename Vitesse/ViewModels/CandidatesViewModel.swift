//
//  CandidatesViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import Foundation

class CandidatesViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
    @Published var alertTitle = ""
    @Published var showAlert = false
    @Published var searchText = ""
    @Published var showFavorites = false
    @Published var transferedMessage = ""
    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            let matchesSearch = searchText.isEmpty || candidate.firstName.contains(searchText) || candidate.lastName.contains(searchText)
            let matchesFav = !showFavorites || candidate.isFavorite
            return matchesSearch && matchesFav
        }
    }
    let api: APIProtocol
    
    init(api: APIProtocol = API.shared) {
        self.api = api
    }
    
    @MainActor
    func fetchCandidates() async {
        do {
            candidates = try await api.call(endPoint: API.CandidatesEndPoints.candidate(id: nil))
            
        } catch {
            alertTitle = error.localizedDescription
            showAlert = true
        }
    }
    
    @MainActor
    func createCandidate(_ candidate: Candidate) async {
        transferedMessage = ""
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
            let newCandidate: Candidate = try await api.call(endPoint: API.CandidatesEndPoints.createCandidate(candidate: candidate))
            candidates.append(newCandidate)
        } catch {
            alertTitle = error.localizedDescription
            showAlert = true
        }
    }
    
    @MainActor
    func deleteCandidates(selectedCandidates: [Candidate]) async {
        for candidate in selectedCandidates {
            guard candidates.contains(where: {$0.id == candidate.id}) else {
                print("cant find \(candidate.firstName)")
                return
            }
            do {
                try await api.call(endPoint: API.CandidatesEndPoints.delete(id: candidate.id))
                candidates.removeAll(where: { $0.id == candidate.id })
            } catch {
                alertTitle = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    func deleteCandidate(at index: IndexSet) async {
        for candidateIndex in index {
            do {
                try await api.call(endPoint: API.CandidatesEndPoints.delete(id: candidates[candidateIndex].id))
                candidates.removeAll(where: { $0.id == candidates[candidateIndex].id })
            } catch {
                alertTitle = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    @MainActor
    func setFavorite(for candidate: Candidate) async {
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
