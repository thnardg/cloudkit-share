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
    @State private var showWelcome: Bool = false
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            if let room = selectedRoom {
                let isShared = CoreDataStack.shared.isShared(object: room)
                
                // HOST
                if !isShared && !showWelcome {
                    VStack {
                        Spacer()
                        Text("Share your love").font(.title).padding().bold()
                        Text("Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá").multilineTextAlignment(.center).font(.subheadline).padding(20)
                        Image(systemName: "heart").resizable().scaledToFit().padding().frame(width: 150)
                        Button(action: {
                            Task {
                                await viewModel.createShare(for: room)
                                showShareController = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "heart.fill")
                                Text("Invite Partner")
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .foregroundColor(.white).bold()
                            .background(Color.black)
                            .cornerRadius(100)
                            .padding()
                        }
                        
                        NavigationLink(destination: NewUserView(room: room)) {
                            Text("Skip")
                                .foregroundStyle(.black)
                                .padding()
                        }
                        Spacer()
                    }
                }
                
                // CONVIDADO
                if showWelcome || isShared {
                    VStack {
                        Spacer()
                        Text("Welcome!").font(.title).padding().bold()
                        Text("Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá Blábláblá").multilineTextAlignment(.center).font(.subheadline).padding(20)
                        Image(systemName: "heart").resizable().scaledToFit().padding().frame(width: 150)
                        NavigationLink(destination: NewUserView(room: room)) {
                            Text("Continue")
                                .padding(.horizontal, 40)
                                .padding(.vertical, 14)
                                .foregroundColor(.white).bold()
                                .background(Color.black)
                                .cornerRadius(100)
                                .padding()
                        }
                    }
                }
            } else {
                Text("Nothing is being shared")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            if viewModel.sharing {
                ProgressView("Sharing...")
            }
        }.onReceive(NotificationCenter.default.publisher(for: .didAcceptCloudKitShare)) { _ in
            showWelcome = true
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
    
    // Função para determinar qual parâmetro passar pra frente
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
