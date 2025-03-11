//
//  EditCandidateView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import SwiftUI

struct EditCandidateView: View {
    @StateObject var viewModel: CandidatViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text(viewModel.candidate.fullName)
                    .font(.cascadia(size: 35))
                    .padding(.bottom, 20)
                Group {
                    Text("Phone")
                    TextField("", text: Binding(
                        get: { viewModel.candidate.phone ?? "" },
                        set: { viewModel.candidate.phone = $0.isEmpty ? nil : $0}
                    ))
                        .padding(5)
                        .background {
                            Rectangle()
                                .stroke()
                        }
                        .keyboardType(.phonePad)
                    Text("Email")
                    TextField("", text: $viewModel.candidate.email)
                        .padding(5)
                        .background {
                            Rectangle()
                                .stroke()
                        }
                        .keyboardType(.emailAddress)
                    Text("LinkedIn")
                    TextField("", text: Binding(
                        get: { viewModel.candidate.linkedinURL ?? "" },
                        set: { viewModel.candidate.linkedinURL = $0.isEmpty ? nil : $0 }
                    ))
                        .padding(5)
                        .background {
                            Rectangle()
                                .stroke()
                        }
                    Text("Note")
                    TextField("", text: Binding(
                        get: { viewModel.candidate.note ?? "" },
                        set: { viewModel.candidate.note = $0.isEmpty ? nil : $0}),
                              axis: .vertical)
                        .lineLimit(5...10)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 25).stroke()
                        }
                }
                .padding(.horizontal, 10)
            }
            .padding()
            .font(.cascadia(size: 20))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.virgil())
                    .foregroundStyle(.black)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        Task {
                            await viewModel.updateCandidate()
                            dismiss()
                        }
                    }
                    .font(.virgil())
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditCandidateView(viewModel: CandidatViewModel(candidate: Candidate(id: UUID().uuidString, firstName: "Tibo", lastName: "Giraudon", email: "tibo@gmail.com", phone: "06 12 12 12 12", isFavorite: false)))
    }
}
