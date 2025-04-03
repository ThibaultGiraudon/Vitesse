//
//  UserViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation
import SwiftUI

/// Handles the user's parameters
class User: ObservableObject {
    /// Tokens for authorization request
    @Published var token = ""
    @Published var isAdmin = false
    @Published var isLoggedIn = false
    static var shared = User()
}
