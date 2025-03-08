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
    
}
