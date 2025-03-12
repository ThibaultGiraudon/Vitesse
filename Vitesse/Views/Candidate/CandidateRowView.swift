//
//  CandidateRowView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 10/03/2025.
//

import SwiftUI

struct CandidateRowView: View {
    var viewModel: CandidatesViewModel
    var candidate: Candidate
    @Binding var isEditing: Bool
    @Binding var selectedCandidates: [Candidate]
    var body: some View {
        HStack {
            if isEditing {
                if selectedCandidates.contains(where: { $0.id == candidate.id }) {
                    Image(systemName: "checkmark.circle.fill")
                }
                else {
                    Image(systemName: "circle")
                }
            }
            Text(candidate.fullName)
            Spacer()
            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
        }
        .font(.virgil())
        .padding()
        .background {
            Rectangle()
                .stroke()
        }
        .onTapGesture {
            if let index = selectedCandidates.firstIndex(where: { $0.id == candidate.id }) {
                selectedCandidates.remove(at: index)
            } else {
                selectedCandidates.append(candidate)
            }
        }
    }
}

#Preview {
    @Previewable @State var isEditing = true
    @Previewable @State var selectedCandidates = [Candidate]()
    CandidateRowView(viewModel: CandidatesViewModel(), candidate: Candidate(id: "123", firstName: "Jean Michel", lastName: "Pierre", email: "jp@gmail.com", phone: "06 06 06 06 06", isFavorite: true), isEditing: $isEditing, selectedCandidates: $selectedCandidates)
}
