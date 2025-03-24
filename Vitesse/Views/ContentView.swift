//
//  ContentView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 07/03/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AppViewModel(user: User.shared)
    @StateObject var user = User.shared
    var body: some View {
        ZStack {
            Group {
                if user.isLoggedIn {
                    CandidatesView()
                } else {
                    LoginView(viewModel: viewModel.authViewModel)
                } 
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
