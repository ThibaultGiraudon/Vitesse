//
//  AddCandidateView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 20/03/2025.
//

import SwiftUI

struct AddCandidateView: View {
    @ObservedObject var viewModel: CandidatesViewModel
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
                        .textFieldStyle()
                    Text("LastName")
                    TextField("", text: $candidate.lastName)
                        .textFieldStyle()
                    Text("Phone")
                    TextField("", text: Binding(
                        get: { candidate.phone ?? "" },
                        set: { candidate.phone = $0.isEmpty ? nil : $0}
                    ))
                    .textFieldStyle(keyboardType: .phonePad)
                    .focused($focused)
                    Text("Email")
                    TextField("", text: $candidate.email)
                        .textFieldStyle(keyboardType: .emailAddress)
                        .focused($focused)
                    Text("LinkedIn")
                    TextField("", text: Binding(
                        get: { candidate.linkedinURL ?? "" },
                        set: { candidate.linkedinURL = $0.isEmpty ? nil : $0 }
                    ))
                    .textFieldStyle(keyboardType: .URL)
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
                        if viewModel.transferedMessage.isEmpty && viewModel.alertTitle.isEmpty {
                            dismiss()
                        }
                    }
                }
                .disabled(shouldDisable)
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlertSheet) {
            
        }
    }
}

struct ParentView: View {
    @State private var showSheet = false
    @StateObject var viewModel = CandidatesViewModel()
    var body: some View {
        VStack {
            Text("Button")
                .onTapGesture {
                    print("tapped")
                    showSheet.toggle()
                }
        }
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                AddCandidateView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ParentView()
    }
}
