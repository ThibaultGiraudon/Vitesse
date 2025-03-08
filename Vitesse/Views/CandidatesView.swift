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
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.candidates, id: \.id) { candidate in
                    HStack {
                        Text(candidate.firstName + " " + candidate.lastName.prefix(1) + ".")
                        Spacer()
                        Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                    }
                    .font(.title)
                    .padding()
                    .background {
                        Rectangle()
                            .stroke()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchCandidates()
        }
        .navigationTitle("Candidats")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Edit") {
                    viewModel.createCandidate()
                }
            }
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

#Preview {
    NavigationStack {
        CandidatesView()
    }
}
