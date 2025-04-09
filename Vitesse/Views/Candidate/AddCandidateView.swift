//
//  AddCandidateView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 20/03/2025.
//

import SwiftUI

struct AddCandidateView: View {
    @StateObject var viewModel: CandidatesViewModel
    @State private var candidate = Candidate()
    @FocusState var focused
    @Environment(\.dismiss) var dismiss
    
    var shouldDisable: Bool {
        candidate.phone == nil || candidate.firstName.isEmpty || candidate.lastName.isEmpty || candidate.email.isEmpty
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Group {
                    if !viewModel.transferedMessage.isEmpty {
                        Text(viewModel.transferedMessage)
                            .foregroundColor(.red)
                    }
                    Text("Firstname")
                    TextField("", text: $candidate.firstName)
                    .padding(5)
                    .background {
                        Rectangle()
                            .stroke()
                    }
                    Text("LastName")
                    TextField("", text: $candidate.lastName)
                    .padding(5)
                    .background {
                        Rectangle()
                            .stroke()
                    }
                    Text("Phone")
                    TextField("", text: Binding(
                        get: { candidate.phone ?? "" },
                        set: { candidate.phone = $0.isEmpty ? nil : $0}
                    ))
                    .padding(5)
                    .background {
                        Rectangle()
                            .stroke()
                    }
                    .keyboardType(.phonePad)
                    .focused($focused)
                    Text("Email")
                    TextField("", text: $candidate.email)
                        .padding(5)
                        .background {
                            Rectangle()
                                .stroke()
                        }
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .focused($focused)
                    Text("LinkedIn")
                    TextField("", text: Binding(
                        get: { candidate.linkedinURL ?? "" },
                        set: { candidate.linkedinURL = $0.isEmpty ? nil : $0 }
                    ))
                    .padding(5)
                    .background {
                        Rectangle()
                            .stroke()
                    }
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                    .focused($focused)
                    Text("Note")
                    TextField("", text: Binding(
                        get: { candidate.note ?? "" },
                        set: { candidate.note = $0.isEmpty ? nil : $0}),
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
        }
        .padding()
        .font(.cascadia(size: 20))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    Task {
                        await viewModel.createCandidate(candidate)
                        if viewModel.transferedMessage.isEmpty {
                            dismiss()
                        }
                    }
                }
                .disabled(shouldDisable)
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK") {
                viewModel.showAlert = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddCandidateView(viewModel: CandidatesViewModel())
    }
}
