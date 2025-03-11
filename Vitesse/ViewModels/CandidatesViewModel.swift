//
//  CandidatesViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import Foundation

class CandidatesViewModel: ObservableObject {
    @Published var candidates: [Candidate] = [
        Candidate(id: UUID().uuidString, firstName: "Jean Pierre", lastName: "Pierre", email: "jp@gmail.com", phone: "06 01 01 01 01", isFavorite: false),
        Candidate(id: UUID().uuidString, firstName: "Jean Michel", lastName: "Pierre", email: "jm@gmail.com", phone: "06 02 02 02 02", isFavorite: false),
        Candidate(id: UUID().uuidString, firstName: "Jean Pierre", lastName: "Michel", email: "jp@gmail.com", phone: "06 03 03 03 03", isFavorite: true),
        Candidate(id: UUID().uuidString, firstName: "Jean Michel", lastName: "Michel", email: "jm@gmail.com", phone: "06 04 04 04 04", isFavorite: true),
    ]
    
    func fetchCandidates() {
        Task {
            do {
                candidates = try await API.shared.call(endPoint: API.CandidatesEndPoints.candidate(id: nil))
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createCandidate() {
        Task {
            do {
                let candidate = try await API.shared.call(endPoint: API.CandidatesEndPoints.createCandidate(email: "t@gmail.com", note: nil, linkedinURL: nil, firstName: "Tibo", lastName: "Giraudon", phone: "06 05 05 05 05")) as Candidate
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteCandidates(selectedCandidates: [Candidate]) {
        Task {
            selectedCandidates.forEach { candidate in
                guard candidates.contains(where: {$0.id == candidate.id}) else {
                    print("cant find \(candidate.firstName)")
                    return
                }
                deleteCandidate(candidate)
            }
        }
    }
    
    func deleteCandidate(_ candidate: Candidate) {
        Task {
            do {
                try await API.shared.call(endPoint: API.CandidatesEndPoints.delete(id: candidate.id))
                fetchCandidates()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setFavorite(for candidate: Candidate) {
        Task {
            do {
                let reponse = try await API.shared.call(endPoint: API.CandidatesEndPoints.favorite(id: candidate.id)) as Candidate
                guard let index = candidates.firstIndex(where: {$0.id == reponse.id}) else {
                    return
                }
                
                candidates[index] = reponse
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func update(candidate: Candidate) {
        if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
            candidates[index] = candidate
        }
    }
    
}
