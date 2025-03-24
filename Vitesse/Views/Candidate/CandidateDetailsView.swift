//
//  CandidateDetailsView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import SwiftUI

struct CandidateDetailsView: View {
    @StateObject var viewModel: CandidateViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showEditSheet = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(viewModel.candidate.fullName)
                    Spacer()
                    Image(systemName: viewModel.candidate.isFavorite ? "star.fill" : "star")
                        .onTapGesture {
                            if User.shared.isAdmin {
                                Task {
                                    await viewModel.setFavorite()
                                }                                
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
                                    .foregroundStyle(.white)
                                    .padding(5)
                                    .background {
                                        Capsule()
                                            .fill(Color.blue)
                                    }
                            }
                        } else {
                            Text("No link provided")
                        }
                    }
                    Text("Note")
                    Text(viewModel.candidate.note ?? "")
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
                // navLink
                NavigationLink {
                    EditCandidateView(viewModel: viewModel)
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Edit")
                        .font(.virgil())
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("backButton")
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                EditCandidateView(viewModel: viewModel)
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            
        }
        .navigationBarBackButtonHidden(true)
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
            viewModel: CandidateViewModel(candidate: Candidate(id: UUID().uuidString, firstName: "Tibo", lastName: "Giraudon", email: "tibo@gmail.com", phone: "06 12 12 12 12", linkedinURL: "https://www.google.com", isFavorite: false))
        )
    }
}
