//
//  UserViewModel.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import Foundation

class User {
    @Published var token = ""
    @Published var isAdmin = false
    static var shared = User()
}
