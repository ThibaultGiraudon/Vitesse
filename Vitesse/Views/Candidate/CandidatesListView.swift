//
//  CandidatesListView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 09/04/2025.
//

import SwiftUI

struct CandidatesListView: View {
    @ObservedObject var viewModel: CandidatesViewModel
    @Binding var isEditing: Bool
    var body: some View {
        List {
            ForEach(viewModel.filteredCandidates, id: \.id) { candidate in
                ZStack {
                    CandidateRowView(viewModel: viewModel, candidate: candidate, isEditing: $isEditing)
                        .foregroundStyle(.black)
                        .padding(.vertical, 5)
                    
                    if !isEditing {
                        NavigationLink {
                            CandidateDetailsView(viewModel: CandidateViewModel(candidate: candidate))
                        } label: {
                            CandidateRowView(viewModel: viewModel, candidate: candidate, isEditing: $isEditing)
                                .foregroundStyle(.black)
                                .padding(.vertical, 5)
                        }
                        .opacity(0)
                    }
                }
            }
            .onDelete { offsets in
                Task {
                    await viewModel.deleteCandidate(at: offsets)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CandidatesListView(viewModel: CandidatesViewModel(), isEditing: .constant(false))
    }
}
