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
                
                Text("Last Name")
                TextField("", text: $viewModel.lastName)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocorrectionDisabled()
                
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
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
                
                Text("Password")
                SecureField("", text: $viewModel.password)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocorrectionDisabled()
                Text("Confirm Password")
                SecureField("", text: $viewModel.confirmPassword)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke()
                    }
                    .autocorrectionDisabled()
            }
            .padding(20)
            Button {
                viewModel.register()
            } label: {
                Text("Create")
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
    }
}

#Preview {
    RegisterView(viewModel: AuthenticationViewModel { _ in })
}
