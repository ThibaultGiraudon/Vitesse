//
//  EditCandidateView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 11/03/2025.
//

import SwiftUI

struct EditCandidateView: View {
    @StateObject var viewModel: EditViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.cascadia(size: 35))
                    .padding(.bottom, 20)
                Group {
                    Text("Phone")
                    TextField("", text: $viewModel.phone)
                        .padding(5)
                        .background {
                            Rectangle()
                                .stroke()
                        }
                        .keyboardType(.phonePad)
                    Text("Email")
                    TextField("", text: $viewModel.email)
                        .padding(5)
                        .background {
                            Rectangle()
                                .stroke()
                        }
                        .keyboardType(.emailAddress)
                    Text("LinkedIn")
                    TextField("", text: $viewModel.linkedinURL)
                        .padding(5)
                        .background {
                            Rectangle()
                                .stroke()
                        }
                    Text("Note")
                    TextField("", text: $viewModel.note, axis: .vertical)
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
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        Task {
                            await viewModel.updateCandidate()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EditCandidateView(viewModel: EditViewModel(candidate: Candidate(id: UUID().uuidString, firstName: "Tibo", isFavorite: true, email: "tibo@gmail.com", lastName: "Giraudon")) { _ in })
}
