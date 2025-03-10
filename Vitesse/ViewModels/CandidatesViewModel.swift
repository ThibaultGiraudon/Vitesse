//
//  CandidatesViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import Foundation

class CandidatesViewModel: ObservableObject {
    @Published var candidates: [Candidate] = [
        Candidate(id: UUID().uuidString, firstName: "Jean Pierre", isFavorite: true, email: "jp@gmail.com", lastName: "Paul"),
        Candidate(id: UUID().uuidString, firstName: "Jean Michel", isFavorite: false, email: "jm@gmail.com", lastName: "Paul"),
        Candidate(id: UUID().uuidString, firstName: "Jean Pierre", isFavorite: true, email: "jp@gmail.com", lastName: "Arak"),
        Candidate(id: UUID().uuidString, firstName: "Jean Michel", isFavorite: false, email: "jm@gmail.com", lastName: "Zazy"),
    ]
    
    func fetchCandidates() {
        Task {
            do {
                candidates = try await API.shared.call(endPoint: API.CandidatesEndPoints.candidate(id: nil))
                
                print(candidates)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createCandidate() {
        Task {
            do {
                let candidate = try await API.shared.call(endPoint: API.CandidatesEndPoints.createCandidate(email: "t@gmail.com", note: nil, linkedinURL: nil, firstName: "Tibo", lastName: "Giraudon", phone: "06 85 99 86 66")) as Candidate
                
                print("Successfuly created new candidate")
                print(candidate)
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
                print("deleting \(candidate.firstName)")
                try await API.shared.call(endPoint: API.CandidatesEndPoints.delete(id: candidate.id))
                print("successfuly deleted \(candidate.firstName)")
                fetchCandidates()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func favorite(candidate: Candidate) {
        Task {
            do {
                var reponse = try await API.shared.call(endPoint: API.CandidatesEndPoints.favorite(id: candidate.id)) as Candidate
                guard let index = candidates.firstIndex(where: {$0.id == reponse.id}) else {
                    return
                }
                
                candidates[index] = reponse
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
