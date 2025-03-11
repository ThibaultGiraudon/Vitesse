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
        viewModel.candidates.filter { candidate in
            let matchesSearch = searchText.isEmpty || candidate.firstName.contains(searchText)
            let matchesFav = !showFav || candidate.isFavorite
            return matchesSearch && matchesFav
        }
    }
    @State private var isEditing = false
    @State private var selectedCandidates = [Candidate]()
    @State private var showFav = false
    
    var body: some View {
        VStack {
            HStack {
                Button(isEditing ? "Cancel" : "Edit") {
                    withAnimation {
                        isEditing.toggle()
                    }
                }
                Spacer()
                Text("Candidats")
                Spacer()
                if isEditing {
                    Button {
                        viewModel.deleteCandidates(selectedCandidates: selectedCandidates)
                        selectedCandidates = []
                        withAnimation {
                            isEditing.toggle()
                        }
                    } label: {
                        Text("Delete")
                    }
                } else {
                    Button {
                        showFav.toggle()
                    } label: {
                        Image(systemName: showFav ? "star.fill" : "star")
                    }
                }
            }
            .padding(.horizontal)
            .foregroundStyle(.black)
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $searchText)
            }
            .font(.virgil(size: 28))
            .padding(3)
            .background {
                Rectangle()
                    .stroke()
            }
            .padding(3)
            ScrollView {
                ForEach(filteredCandidate, id: \.id) { candidate in
                    ZStack {
                        CandidateRowView(viewModel: viewModel, candidate: candidate, isEditing: $isEditing, selectedCandidates: $selectedCandidates)
                            .foregroundStyle(.black)
                            .padding(.vertical, 5)
                        
                        if !isEditing {
                            NavigationLink {
                                CandidateDetailsView(viewModel: CandidatViewModel(candidate: candidate))
                            } label: {
                                CandidateRowView(viewModel: viewModel, candidate: candidate, isEditing: $isEditing, selectedCandidates: $selectedCandidates)
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 5)
                                    .opacity(0)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchCandidates()
        }
        .font(.virgil())
    }
}

#Preview {
    NavigationStack {
        CandidatesView()
    }
}
