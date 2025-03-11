//
//  CandidateDetailsView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import SwiftUI

struct CandidateDetailsView: View {
    var viewModel: CandidatesViewModel
    @State var candidate: Candidate
    @State private var showEditSheet = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(candidate.firstName + " " + candidate.lastName.prefix(1) + ".")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .onTapGesture {
                            viewModel.setFavorite(for: candidate)
                        }
                }
                .font(.largeTitle)
                .padding()
                Group {
                    row("Phone", info: candidate.phone)
                    row("Email", info: candidate.email)
                    HStack {
                        Text("LinkedIn")
                        if let linkedinURL = candidate.linkedinURL, let url = URL(string: linkedinURL) {
                            Link(destination: url) {
                                Text("Go on LinkedIn")
                            }
                        } else {
                            Text("No link provided")
                        }
                    }
                    Text("Note")
                    Text(candidate.note ?? "N/A")
                        .font(.virgil)
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
                    print("taped")
                    showEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                EditCandidateView(viewModel: EditViewModel(candidate: candidate, completion: { response in
                    viewModel.update(candidate: response)
                    candidate = response
                }))
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
            viewModel: CandidatesViewModel(),
            candidate: Candidate(id: UUID().uuidString, firstName: "Tibo", isFavorite: true, email: "tibo@gmail.com", lastName: "Giraudon")
        )
    }
}
