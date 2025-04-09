//
//  CandidatesView.swift
//  Vitesse
//
//  Created by Thibault Giraudon on 08/03/2025.
//

import SwiftUI

struct CandidatesView: View {
    @ObservedObject var viewModel = CandidatesViewModel()
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @State private var showAddCandidateSheet: Bool = false
    
    var body: some View {
        VStack {
            HeaderView(viewModel: viewModel,
                       isEditing: $isEditing,
                       showAddCandidateSheet: $showAddCandidateSheet,
                       showDeleteConfirmation: $showDeleteConfirmation)
           
            CandidatesListView(viewModel: viewModel, isEditing: $isEditing)
        }
        .onAppear {
            Task {
                await viewModel.fetchCandidates()
            }
        }
        .overlay {
            EmptyCandidatesOverlayView(viewModel: viewModel)
        }
        .sheet(isPresented: $showAddCandidateSheet, content: {
            NavigationStack {
                AddCandidateView(viewModel: viewModel)
            }
        })
        .font(.virgil())
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) { }
        .alert("Warning" , isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteCandidates()
                }
                withAnimation {
                    isEditing.toggle()
                }
            }
            Button("Cancel", role: .cancel) {
                viewModel.selectedCandidates = []
                withAnimation {
                    isEditing.toggle()
                }
            }
        } message: {
            Text("Are you sure you want to delete \(viewModel.selectedCandidates.count) candidates?")
        }
    }
}

#Preview {
    NavigationStack {
        CandidatesView()
    }
}
