//
//  EmptyCandidatesOverlayView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 09/04/2025.
//

import SwiftUI

struct EmptyCandidatesOverlayView: View {
    @ObservedObject var viewModel: CandidatesViewModel
    var body: some View {
        VStack {
            Spacer()
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
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .onTapGesture {
                        User.shared.isAdmin = false
                        User.shared.token = ""
                        User.shared.isLoggedIn = false
                    }
                    .padding()
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding()
            }
        }
    }
}
