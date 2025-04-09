//
//  HeaderView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 09/04/2025.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: CandidatesViewModel
    @Binding var isEditing: Bool
    @Binding var showAddCandidateSheet: Bool
    @Binding var showDeleteConfirmation: Bool
    var body: some View {
        HStack {
            Button(isEditing ? "Cancel" : "Edit") {
                viewModel.selectedCandidates.removeAll()
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
                .disabled(viewModel.selectedCandidates.isEmpty)
                .foregroundStyle(viewModel.selectedCandidates.isEmpty ? .gray : .black)
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
    }
}
