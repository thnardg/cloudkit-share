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
            if let room = selectedRoom {
                let isShared = CoreDataStack.shared.isShared(object: room)
                let isOwner = CoreDataStack.shared.isOwner(object: room)
                
                // HOST
                if !isShared && !showWelcome {
                    VStack {
                        Spacer()
                        Text("Invite Your Partner").font(.title).padding().bold().multilineTextAlignment(.center)
                        Text("Connect with your partner for a complete experience and celebrate love and affection every day!").multilineTextAlignment(.center).font(.subheadline).padding(.horizontal, 25)
                        Spacer()
                        RoundedRectangle(cornerRadius: 22).frame(width: 276, height: 383).foregroundStyle(.gray.opacity(0.2)).padding()
                        
                        OnboardingButton(title: "Invite your Partner") {
                            Task {
                                await viewModel.createShare(for: room)
                                showShareController = true
                            }
                        }
                        
                        NavigationLink(destination: NewUserView(room: room)) {
                            Text("Skip")
                                .foregroundStyle(.purple)
                                .padding()
                        }
                        Spacer()
                    }
                }
                
                if isShared && isOwner || isOwner && showWelcome {
                    VStack {
                        Spacer()
                        Text("Invite Your Partner").font(.title).padding().bold().multilineTextAlignment(.center)
                        Text("Connect with your partner for a complete experience and celebrate love and affection every day!").multilineTextAlignment(.center).font(.subheadline).padding(.horizontal, 25)
                        Spacer()
                        RoundedRectangle(cornerRadius: 22).frame(width: 276, height: 383).foregroundStyle(.gray.opacity(0.2)).padding()
                        
                        OnboardingButton(title: "Invite your Partner") {
                            Task {
                                await viewModel.createShare(for: room)
                                showShareController = true
                            }
                        }
                        
                        NavigationLink(destination: NewUserView(room: room)) {
                            Text("Continue")
                                .font(.system(.body, design: .rounded)).bold()
                                .padding(.horizontal, 40)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.purple)
                                .cornerRadius(100)
                        }
                        Spacer()
                    }
                }
                
                // CONVIDADO
                if showWelcome && !isOwner || isShared && !isOwner {
                    VStack {
                        Spacer()
                        Text("You've got a special invitation!").font(.title).padding().bold().multilineTextAlignment(.center)
                        Text("Accept the invite to unlock special features that help keep your love strong and your connection even closer.").multilineTextAlignment(.center).font(.subheadline).padding(.horizontal, 25)
                        Spacer()
                        RoundedRectangle(cornerRadius: 22).frame(maxWidth: 276, maxHeight: 383).foregroundStyle(.gray.opacity(0.2)).padding()
                        
                        NavigationLink(destination: NewUserView(room: room)) {
                            Text("Accept")
                                .font(.system(.body, design: .rounded)).bold()
                                .padding(.horizontal, 40)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.purple)
                                .cornerRadius(100)
                        }
                        Spacer()
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
            selectedRoom = determineRoom()
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
