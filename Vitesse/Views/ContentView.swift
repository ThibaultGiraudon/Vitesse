//
//  ContentView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var user = User.shared
    var body: some View {
        Group {
            if user.isLoggedIn {
                CandidatesView()
            } else {
                LoginView(viewModel: AuthenticationViewModel())
            } 
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
