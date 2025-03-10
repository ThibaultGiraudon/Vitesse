//
//  CandidatesView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import SwiftUI

struct CandidatesView: View {
    @ObservedObject var viewModel = CandidatesViewModel()
    @State private var searchText = "" // move in VM
    var filteredCandidate: [Candidate] {
        return searchText.isEmpty ? viewModel.candidates : self.viewModel.candidates.filter { candidate in
            candidate.firstName.contains(searchText)
        }
    }
    @State private var isEditing = false
    @State private var selectedCandidates = [Candidate]()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $searchText)
            }
            .font(.title)
            .padding(3)
            .background {
                Rectangle()
                    .stroke()
            }
            .padding(3)
            List(filteredCandidate, id: \.id) { candidate in
                CandidateRowView(viewModel: viewModel, candidate: candidate, isEditing: $isEditing, selectedCandidates: $selectedCandidates)
            }
            .listStyle(.plain)
        }
        .onAppear {
            viewModel.fetchCandidates()
        }
        .navigationTitle("Candidats")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(isEditing ? "Cancel" : "Edit") {
                    isEditing.toggle()
                }
            }
            if isEditing {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.deleteCandidates(selectedCandidates: selectedCandidates)
                        selectedCandidates = []
                        isEditing.toggle()
                    } label: {
                        Text("Delete")
                    }
                }
            } else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.fetchCandidates()
                    } label: {
                        Image(systemName: "star")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CandidatesView()
    }
}
