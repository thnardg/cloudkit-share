//
//  ShareRoomView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import SwiftUI

struct ShareRoomView: View {
    let room: Room
    @StateObject private var viewModel = ShareRoomViewModel()

    @State private var showShareController = false
    
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                Task {
                    await viewModel.createShare(for: room)
                    showShareController = true
                }
            }) {
                HStack {
                    Image(systemName: "arrow.up.heart.fill")
                    Text("Invite Partner")
                }
                .padding()
                .foregroundColor(.white).bold()
                .background(Color.purple)
                .cornerRadius(100)
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
            if viewModel.sharing {
                ProgressView("Sharing...")
            }
        }
            VStack {
                if countParticipants() {
                    NavigationLink(destination: NewUserView(room: room)) {
                        Text("Create users")
                        Image(systemName: "arrow.right")
                    }.padding()
                        .foregroundColor(.white).bold()
                        .background(Color.purple)
                        .cornerRadius(100)
                        .padding(.horizontal)
                }
                Spacer()
            }
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
