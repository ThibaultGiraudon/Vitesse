//
//  CandidatViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import Foundation

class CandidatViewModel: ObservableObject {
    @Published var candidate: Candidate
    
    init(candidate: Candidate) {
        self.candidate = candidate
    }
    
    func setFavorite() async {
        do {
            candidate = try await API.shared.call(endPoint: API.CandidatesEndPoints.favorite(id: candidate.id))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateCandidate() async {
        do {
            candidate = try await API.shared.call(endPoint: API.CandidatesEndPoints.update(candidate: candidate)) as Candidate
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
