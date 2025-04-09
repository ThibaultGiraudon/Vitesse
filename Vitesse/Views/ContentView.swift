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
        ZStack(alignment: .bottomTrailing) {
            Group {
                if user.isLoggedIn {
                    CandidatesView()
                } else {
                    LoginView(viewModel: AuthenticationViewModel())
                } 
            }
            if user.isLoggedIn {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .onTapGesture {
                        User.shared.isAdmin = false
                        User.shared.token = ""
                        User.shared.isLoggedIn = false
                    }
                    .padding()
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
