//
//  RegisterView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState var focused
    var body: some View {
        VStack {
            Text("Register")
                .font(.cascadia(size: 50))
            VStack(alignment: .leading) {
                Text("First Name")
                TextField("", text: $viewModel.firstName)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocorrectionDisabled()
                    .focused($focused)
                
                Text("Last Name")
                TextField("", text: $viewModel.lastName)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocorrectionDisabled()
                    .focused($focused)
                
                Text("Email")
                TextField("", text: $viewModel.email)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .focused($focused)
                
                
                Text("Password")
                SecureField("", text: $viewModel.password)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocorrectionDisabled()
                    .focused($focused)
                
                Text("Confirm Password")
                SecureField("", text: $viewModel.confirmPassword)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocorrectionDisabled()
                    .focused($focused)
                
                if !viewModel.transferedMessage.isEmpty {
                    Text(viewModel.transferedMessage)
                        .foregroundStyle(.red)
                }
            }
            .padding(20)
            Spacer()
            Button {
                Task {
                    await viewModel.register()
                    focused = false
                    if User.shared.isLoggedIn {
                        dismiss()
                    }
                }
            } label: {
                Text("Create")
                    .frame(maxWidth: 100)
                    .padding()
                    .background {
                        Rectangle()
                            .stroke()
                    }
                    .foregroundStyle(viewModel.shouldDisable ? .gray : .black)
            }
            .disabled(viewModel.shouldDisable)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("backButton")
                        Spacer()
                    }
                }
            }
        }
        .font(.cascadia())
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK") {
                viewModel.alertTitle = ""
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        RegisterView(viewModel: AuthenticationViewModel())
    }
}
