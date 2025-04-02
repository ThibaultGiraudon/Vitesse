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
    let api: APIProtocol
    
    
    init(api: APIProtocol = API.shared) {
        self.api = api
    }
    
    @MainActor
    func login() async {
        do {
            guard email.isValidEmail else {
                transferedMessage = "Invalid email format."
                return
            }
            
            let response: Token = try await api.call(endPoint: API.AuthEndPoints.auth(email: email, password: password))
            
            User.shared.token = response.token
            User.shared.isAdmin = response.isAdmin
            User.shared.isLoggedIn = true
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
    
//    @MainActor
    func register() async {
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
            
            try await api.call(endPoint: API.AuthEndPoints.register(email: email, password: password, firstName: firstName, lastName: lastName))
            
            await self.login()
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
