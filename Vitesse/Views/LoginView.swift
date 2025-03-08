//
//  LoginView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text("Email/Username")
                TextField("", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                Text("Password")
                SecureField("", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                Button("Forgot password?") {}
            }
            .padding(30)
            Button {
                viewModel.login()
                print(User.shared.token)
            } label: {
                Text("Sign In")
                    .foregroundStyle(.blue)
                    .padding()
                    .background {
                        Rectangle()
                            .stroke()
                    }
            }
            NavigationLink {
                RegisterView(viewModel: viewModel)
            } label: {
                Text("Register")
                    .foregroundStyle(.blue)
                    .padding()
                    .background {
                        Rectangle()
                            .stroke()
                    }
            }
        }
        .onAppear {
            viewModel.email = "admin@vitesse.com"
            viewModel.password = "test123"
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(viewModel: AuthenticationViewModel {_ in })
    }
}
