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
                    .textFieldStyle()
                    .focused($focused)
                
                Text("Last Name")
                TextField("", text: $viewModel.lastName)
                    .textFieldStyle()
                    .focused($focused)
                
                Text("Email")
                TextField("", text: $viewModel.email)
                    .textFieldStyle(keyboardType: .emailAddress)
                    .focused($focused)
                
                
                Text("Password")
                SecureField("", text: $viewModel.password)
                    .textFieldStyle()
                    .focused($focused)
                
                Text("Confirm Password")
                SecureField("", text: $viewModel.confirmPassword)
                    .textFieldStyle()
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        RegisterView(viewModel: AuthenticationViewModel())
    }
}
