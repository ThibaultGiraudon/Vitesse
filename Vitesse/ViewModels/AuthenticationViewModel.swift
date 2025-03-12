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
    @Published var transferedMessage = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    var shouldDisable: Bool {
        email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty || confirmPassword.isEmpty
    }
    
    let onLogginSucceed: ((Token) -> ())
    
    init(_ callback: @escaping (Token) -> ()) {
        onLogginSucceed = callback
    }
    
    @MainActor
    func login() {
        Task {
            do {
                guard email.isValidEmail else {
                    transferedMessage = "Invalid email format."
                    return
                }
                
                let response: Token = try await API.shared.call(endPoint: API.AuthEndPoints.auth(email: email, password: password))
                
                onLogginSucceed(response)
            } catch let error as API.Error {
                switch error {
                case .custom(let reason):
                    transferedMessage = reason
                default:
                    alertTitle = error.localizedDescription
                    showAlert = true
                }
            } catch {
                alertTitle = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    @MainActor
    func register() {
        Task {
            do {
                guard password == confirmPassword else {
                    transferedMessage = "Passwords don't match."
                    return
                }
                
                guard password.count >= 6 else {
                    transferedMessage = "Password must be at least 6 characters long."
                    return
                }
                
                guard email.isValidEmail else {
                    transferedMessage = "Invalid email format."
                    return
                }
                
                try await API.shared.call(endPoint: API.AuthEndPoints.register(email: email, password: password, firstName: firstName, lastName: lastName))
                
                self.login()
            } catch let error as API.Error {
                switch error {
                case .custom(let reason):
                        print("error")
                    transferedMessage = reason
                    case .uniqueConstraint:
                        transferedMessage = error.localizedDescription
                default:
                        print("error2")
                    alertTitle = error.localizedDescription
                    showAlert = true
                }
            } catch {
                alertTitle = error.localizedDescription
                showAlert = true
            }
        }
    }
    
}
