//
//  EditCandidateView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import SwiftUI

struct EditCandidateView: View {
    @ObservedObject var viewModel: CandidateViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focused
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Group {
                    if !viewModel.transferedMessage.isEmpty {
                        Text(viewModel.transferedMessage)
                            .foregroundStyle(.red)
                    }
                    Text("Firstname")
                    TextField("", text: $viewModel.editedCandidate.firstName)
                        .textFieldStyle()
                        .focused($focused)
                    Text("Lastname")
                    TextField("", text: $viewModel.editedCandidate.lastName)
                        .textFieldStyle()
                        .focused($focused)
                    Text("Phone")
                    TextField("", text: Binding(
                        get: { viewModel.editedCandidate.phone ?? "" },
                        set: { viewModel.editedCandidate.phone = $0.isEmpty ? nil : $0}
                    ))
                    .textFieldStyle(keyboardType: .phonePad)
                        .focused($focused)
                    Text("Email")
                    TextField("", text: $viewModel.editedCandidate.email)
                        .textFieldStyle(keyboardType: .emailAddress)
                        .focused($focused)
                    Text("LinkedIn")
                    TextField("", text: Binding(
                        get: { viewModel.editedCandidate.linkedinURL ?? "" },
                        set: { viewModel.editedCandidate.linkedinURL = $0.isEmpty ? nil : $0 }
                    ))
                        .textFieldStyle(keyboardType: .URL)
                        .focused($focused)
                    Text("Note")
                    TextField("", text: Binding(
                        get: { viewModel.editedCandidate.note ?? "" },
                        set: { viewModel.editedCandidate.note = $0.isEmpty ? nil : $0}),
                              axis: .vertical)
                        .lineLimit(5...10)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 25).stroke()
                        }
                        .focused($focused)
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
                            focused = false
                            await viewModel.updateCandidate()
                            if viewModel.transferedMessage.isEmpty && viewModel.alertTitle.isEmpty {
                                dismiss()
                            }
                        }
                    }
                    .font(.virgil())
                    .disabled(viewModel.shouldDisable)
                    .foregroundStyle(viewModel.shouldDisable ? .gray : .black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditCandidateView(viewModel: CandidateViewModel(candidate: Candidate(id: UUID().uuidString, firstName: "Tibo", lastName: "Giraudon", email: "tibo@gmail.com", phone: "06 12 12 12 12", isFavorite: false)))
    }
}
