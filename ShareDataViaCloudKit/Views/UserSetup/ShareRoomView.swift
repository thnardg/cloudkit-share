//
//  ShareRoomView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import SwiftUI
import CoreData

struct ShareRoomView: View {
    @FetchRequest(
        entity: Room.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Room.timestamp, ascending: false)],
        animation: .default
    )
    private var rooms: FetchedResults<Room>
    
    @StateObject private var viewModel = ShareRoomViewModel()
    @State private var showShareController = false
    @State private var selectedRoom: Room?
    
    var body: some View {
        VStack {
            Spacer()
            
            // Exibe o nome da sala, se disponível
            if let room = selectedRoom {
                Text(room.name ?? "Unnamed Room")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
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
            } else {
                Text("Nenhuma sala disponível")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            if viewModel.sharing {
                ProgressView("Sharing...")
            }
        }
        .onAppear {
            selectedRoom = determineRoom()
        }
        .sheet(isPresented: $showShareController) {
            if let room = selectedRoom, let share = CoreDataStack.shared.getShare(room) {
                CloudSharingView(share: share, container: CoreDataStack.shared.ckContainer, room: room)
                    .ignoresSafeArea()
            }
        }
    }
    
    // Função para determinar qual sala usar
    private func determineRoom() -> Room? {
        if let sharedRoom = rooms.first(where: { room in
            CoreDataStack.shared.isShared(object: room) && !CoreDataStack.shared.isOwner(object: room)
        }) {
            return sharedRoom
        }
        
        if let ownedRoom = rooms.first(where: { room in
            CoreDataStack.shared.isOwner(object: room)
        }) {
            return ownedRoom
        }
        
        return rooms.first
    }
}
