//
//  ShareRoomView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import SwiftUI

struct ShareRoomView: View {
    let room: Room
    @StateObject private var viewModel = NoteDetailViewModel()
    @State private var showShareController = false
    
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    await viewModel.createShare(for: room)
                    showShareController = true
                }
            }) {
                Text("Share This Room")
            }.buttonStyle(BorderedProminentButtonStyle())
            .padding()
            
            if viewModel.sharing {
                ProgressView("Sharing...")
            }
            
            if countParticipants() {
                NavigationLink(destination: NoteDetailView(room: room)) {
                    Text("Go to Notes")
                }.buttonStyle(BorderedButtonStyle())
                .padding()
            }
        }
        .navigationTitle("Share Room")
        .sheet(isPresented: $showShareController) {
            let share = CoreDataStack.shared.getShare(room)!
            CloudSharingView(share: share, container: CoreDataStack.shared.ckContainer, room: room)
                .ignoresSafeArea()
        }
        
    }
    
    // TODO: separar isso numa view model
    private func countParticipants() -> Bool {
        if let share = CoreDataStack.shared.getShare(room) {
            return share.participants.count >= 2
        }
        return false
    }
    
}
