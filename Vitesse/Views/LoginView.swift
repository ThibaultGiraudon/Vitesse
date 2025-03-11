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
                .font(.cascadia(size: 50))
            VStack(alignment: .leading) {
                Text("Email/Username")
                TextField("", text: $viewModel.email)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                Text("Password")
                SecureField("", text: $viewModel.password)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                Button("Forgot password?") {}
                    .font(.cascadia(size: 12))
                    .foregroundStyle(.gray)
            }
            .padding(30)
            Button {
                viewModel.login()
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
