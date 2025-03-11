//
//  CandidateDetailsView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import SwiftUI

struct CandidateDetailsView: View {
    @StateObject var viewModel: CandidatViewModel
    @State private var showEditSheet = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(viewModel.candidate.fullName)
                    Spacer()
                    Image(systemName: viewModel.candidate.isFavorite ? "star.fill" : "star")
                        .onTapGesture {
                            Task {
                                await viewModel.setFavorite()
                            }
                        }
                }
                .font(.largeTitle)
                .padding()
                Group {
                    row("Phone", info: viewModel.candidate.phone)
                    row("Email", info: viewModel.candidate.email)
                    HStack {
                        Text("LinkedIn")
                        if let linkedinURL = viewModel.candidate.linkedinURL, let url = URL(string: linkedinURL) {
                            Link(destination: url) {
                                Text("Go on LinkedIn")
                            }
                        } else {
                            Text("No link provided")
                        }
                    }
                    Text("Note")
                    Text(viewModel.candidate.note ?? "N/A")
                        .font(.virgil())
                        .padding(.horizontal, 2)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke()
                        }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
        }
        .font(.cascadia())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    showEditSheet = true
                }
                .font(.virgil())
                .foregroundStyle(.black)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                EditCandidateView(viewModel: viewModel)
            }
        }
    }
    
    func row(_ title: String, info: String?) -> some View {
        HStack {
            Text(title)
            Text(info ?? "N/A")
        }
    }
    
}

#Preview {
    NavigationStack {
        CandidateDetailsView(
            viewModel: CandidatViewModel(candidate: Candidate(id: UUID().uuidString, firstName: "Tibo", lastName: "Giraudon", email: "tibo@gmail.com", phone: "Giraudon", isFavorite: false))
        )
    }
}
