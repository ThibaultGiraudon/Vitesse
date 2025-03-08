//
//  AuthenticationViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    
    let onLogginSucceed: ((Token) -> ())
    
    init(_ callback: @escaping (Token) -> ()) {
        onLogginSucceed = callback
    }
    
    func login() {
        Task {
            do {
                let response: Token = try await API.shared.call(endPoint: API.AuthEndPoints.auth(email: email, password: password))
                
                print(response.token)
                onLogginSucceed(response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func register() {
        Task {
            do {
                errorMessage = nil
                try await API.shared.call(endPoint: API.AuthEndPoints.register(email: email, password: password, firstName: firstName, lastName: lastName))
                self.login()
            } catch let error as API.Error where error == .uniqueConstraint{
                errorMessage = error.localizedDescription
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
