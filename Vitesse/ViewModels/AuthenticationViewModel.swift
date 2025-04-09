//
//  AuthenticationViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

/// ViewModel handling authentication logic.
@MainActor
class AuthenticationViewModel: ObservableObject {
    /// User's input
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var confirmPassword = ""
    
    /// Handles error.
    @Published var transferedMessage = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    
    /// Determines if the registration button should be disabled.
    var shouldDisable: Bool {
        email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty || confirmPassword.isEmpty
    }
    
    /// API instance used for authentication requests.
    let api: API
    
    /// Initializes the authentication ViewModel with an API instance for injection tests.
    init(session: URLSessionProtocol = URLSession.shared) {
        self.api = API(session: session)
    }
    
    /// Attempts to log in the user.
    /// - Updates `User.shared` upon success.
    /// - Displays error messages in case of failure.
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
    
    /// Attempts to register a new user.
    /// - Performs validation checks before sending request.
    /// - In case of success automatically log in the suer.
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
            
            let _ = try await api.call(endPoint: API.AuthEndPoints.register(email: email, password: password, firstName: firstName, lastName: lastName)) as EmptyResponse
            
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
