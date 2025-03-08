//
//  RegisterView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text("First Name")
                TextField("", text: $viewModel.firstName)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                
                Text("Last Name")
                TextField("", text: $viewModel.lastName)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                
                Text("Email")
                TextField("", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
                
                Text("Password")
                SecureField("", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                Text("Confirm Password")
                SecureField("", text: $viewModel.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
            }
            .padding(20)
            Button {
                viewModel.register()
            } label: {
                Text("Create")
                    .padding()
                    .background {
                        Rectangle()
                            .stroke()
                    }
            }
        }
    }
}

#Preview {
    RegisterView(viewModel: AuthenticationViewModel { _ in })
}
