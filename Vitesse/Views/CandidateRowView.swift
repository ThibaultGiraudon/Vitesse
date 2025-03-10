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
                Button {
                    if let index = selectedCandidates.firstIndex(where: { $0.id == candidate.id }) {
                        selectedCandidates.remove(at: index)
                    }
                    else {
                        selectedCandidates.append(candidate)
                    }
                } label: {
                    if selectedCandidates.contains(where: { $0.id == candidate.id }) {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    else {
                        Image(systemName: "circle")
                    }
                }
            }
            Text(candidate.firstName + " " + candidate.lastName.prefix(1) + ".")
            Spacer()
            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                .onTapGesture {
                    print(viewModel.candidates)
                    viewModel.favorite(candidate: candidate)
                }
        }
        .font(.title)
        .padding()
        .background {
            Rectangle()
                .stroke()
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
//    @Previewable @State var isEditing = true
//    @Previewable @State var selectedCandidates = [Candidate]()
//    CandidateRowView(candidate: Candidate(id: "123", firstName: "Jean Michel", isFavorite: false, email: "jp@gmail.com", lastName: "Papin"), isEditing: $isEditing, selectedCandidates: $selectedCandidates)
}
