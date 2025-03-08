//
//  AppViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
    @MainActor
    var authViewModel: AuthenticationViewModel {
        return AuthenticationViewModel { token in
            User.shared.isAdmin = token.isAdmin
            User.shared.token = token.token
            User.shared.isLoggedIn = true
        }
    }
}
