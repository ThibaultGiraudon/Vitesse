//
//  LoginView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @FocusState var focused
    var body: some View {
        VStack {
            Text("Login")
                .font(.cascadia(size: 50))
            VStack(alignment: .leading) {
                Text("Email/Username")
                TextField("", text: $viewModel.email)
                    .textFieldStyle(8, keyboardType: .emailAddress)
                    .focused($focused)
                
                Text("Password")
                SecureField("", text: $viewModel.password)
                    .textFieldStyle(8)
                    .focused($focused)
                
                Button("Forgot password?") {}
                    .font(.cascadia(size: 12))
                    .foregroundStyle(.gray)
                
                if !viewModel.transferedMessage.isEmpty {
                    Text(viewModel.transferedMessage)
                        .foregroundStyle(.red)
                }
            }
            .padding(30)
            
            Button {
                Task {
                    focused = false
                    await viewModel.login()
                }
            } label: {
                Text("Sign In")
                    .frame(maxWidth: 100)
                    .padding()
                    .background {
                        Rectangle()
                            .stroke()
                    }
                    .foregroundStyle(.black)
            }
            .padding(.bottom)
            
            NavigationLink {
                RegisterView(viewModel: viewModel)
            } label: {
                Text("Register")
                    .frame(maxWidth: 100)
                    .padding()
                    .background {
                        Rectangle()
                            .stroke()
                    }
                    .foregroundStyle(.black)
            }
        }
        .font(.cascadia())
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK") {
                viewModel.alertTitle = ""
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(viewModel: AuthenticationViewModel())
    }
}
