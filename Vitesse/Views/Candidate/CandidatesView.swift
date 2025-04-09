//
//  CandidatesView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import SwiftUI

struct CandidatesView: View {
    @ObservedObject var viewModel = CandidatesViewModel()
    @State private var isEditing = false
    @State private var selectedCandidates = [Candidate]()
    @State private var showDeleteConfirmation = false
    @State private var showAddCandidateSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(isEditing ? "Cancel" : "Edit") {
                    selectedCandidates.removeAll()
                    withAnimation {
                        isEditing.toggle()
                    }
                }
                Spacer()
                Text("Candidats")
                Spacer()
                Button {
                    showAddCandidateSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                if isEditing {
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        Text("Delete")
                    }
                    .disabled(selectedCandidates.isEmpty)
                    .foregroundStyle(selectedCandidates.isEmpty ? .gray : .black)
                } else {
                    Button {
                        viewModel.showFavorites.toggle()
                    } label: {
                        Image(systemName: viewModel.showFavorites ? "star.fill" : "star")
                    }
                }
            }
            .padding(.horizontal)
            .foregroundStyle(.black)
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $viewModel.searchText)
            }
            .font(.virgil(size: 28))
            .padding(3)
            .background {
                Rectangle()
                    .stroke()
            }
            .padding(3)
            List {
                ForEach(viewModel.filteredCandidates, id: \.id) { candidate in
                    ZStack {
                        CandidateRowView(viewModel: viewModel, candidate: candidate, isEditing: $isEditing, selectedCandidates: $selectedCandidates)
                            .foregroundStyle(.black)
                            .padding(.vertical, 5)
                        
                        if !isEditing {
                            NavigationLink {
                                CandidateDetailsView(viewModel: CandidateViewModel(candidate: candidate))
                            } label: {
                                CandidateRowView(viewModel: viewModel, candidate: candidate, isEditing: $isEditing, selectedCandidates: $selectedCandidates)
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
        .onAppear {
            Task {
                await viewModel.fetchCandidates()
            }
        }
        .overlay {
            if viewModel.candidates.isEmpty {
                VStack {
                    Text("No candidates found")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("First add a candidate")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            } else if viewModel.filteredCandidates.isEmpty && (!viewModel.searchText.isEmpty || viewModel.showFavorites) {
                VStack {
                    Text("No candidates found matching search criteria")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .sheet(isPresented: $showAddCandidateSheet, content: {
            NavigationStack {
                AddCandidateView(viewModel: viewModel)
            }
        })
        .font(.virgil())
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            
        }
        .alert("Warning" , isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteCandidates(selectedCandidates: selectedCandidates)
                    selectedCandidates = []
                }
                withAnimation {
                    isEditing.toggle()
                }
            }
            Button("Cancel", role: .cancel) {
                selectedCandidates = []
                withAnimation {
                    isEditing.toggle()
                }
            }
        } message: {
            Text("Are you sure you want to delete \(selectedCandidates.count) candidates?")
        }
    }
}

#Preview {
    NavigationStack {
        CandidatesView()
    }
}
