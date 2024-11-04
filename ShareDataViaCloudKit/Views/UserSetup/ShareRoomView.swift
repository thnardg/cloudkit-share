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
            
            // Display the room name
            Text(room.name ?? "Unnamed Room")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Check if the current user is the owner and if the room is shared
            let isOwner = CoreDataStack.shared.isOwner(object: room)
            let isShared = CoreDataStack.shared.isShared(object: room)


                if !isShared {
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
                }
            
            
            // Show Proceed to Create Users button if the room is shared
            if isShared {
                NavigationLink(destination: NewUserView(room: room)) {
                    Text("Proceed to Create Users")
                        .padding()
                        .foregroundColor(.white).bold()
                        .background(Color.purple)
                        .cornerRadius(100)
                        .padding(.horizontal)
                }
            }

            // Show a progress view if sharing is in progress
            if viewModel.sharing {
                ProgressView("Sharing...")
            }
        }
        .sheet(isPresented: $showShareController) {
            if let share = CoreDataStack.shared.getShare(room) {
                CloudSharingView(share: share, container: CoreDataStack.shared.ckContainer, room: room)
                    .ignoresSafeArea()
            }
        }
    }
}
