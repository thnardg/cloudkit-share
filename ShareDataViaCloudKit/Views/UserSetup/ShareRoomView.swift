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
    @Environment(\.presentationMode) private var presentationMode

    @StateObject private var viewModel = ShareRoomViewModel()
    @State private var showShareController = false
    @State private var selectedRoom: Room?

    var body: some View {
        ZStack {
            if let room = selectedRoom {
                let isShared = CoreDataStack.shared.isShared(object: room)
                let isOwner = CoreDataStack.shared.isOwner(object: room)
                
                // HOST
                if !isShared {
                    VStack {
                        Spacer()
                        Text("Invite Your Partner").font(.system(.title, design: .rounded)).padding().bold().multilineTextAlignment(.center)
                        Text("Connect with your partner for a complete experience and celebrate love and affection every day!").multilineTextAlignment(.center)
                            .font(.system(.subheadline, design: .rounded)).padding(.horizontal)
                        Spacer()
                        Image(.selos1).frame(maxWidth: 276, maxHeight: 383)
                            .aspectRatio(1, contentMode: .fit).padding(.vertical, 40)
                        OnboardingButton(title: "Invite your Partner") {
                            Task {
                                await viewModel.createShare(for: room)
                                showShareController = true
                            }
                        }
                        
                        NavigationLink(destination: NewUserView(room: room)) {
                            Text("Skip")
                                .foregroundStyle(.purple)
                                .font(.system(.body, design: .rounded))
                                .padding()
                        }
                        Spacer()
                    }
                }
                
                if isShared && isOwner {
                    VStack {
                        Spacer()
                        Text("Invite Your Partner").font(.system(.title, design: .rounded)).padding().bold().multilineTextAlignment(.center)
                        Text("Connect with your partner for a complete experience and celebrate love and affection every day!").multilineTextAlignment(.center)
                            .font(.system(.subheadline, design: .rounded)).padding(.horizontal)
                        Spacer()
                        Image(.selos1).frame(maxWidth: 276, maxHeight: 383)
                            .aspectRatio(1, contentMode: .fit).padding(.vertical, 40)
                        
                        NavigationLink(destination: NewUserView(room: room)) {
                            Text("Continue")
                                .font(.system(.body, design: .rounded)).bold()
                                .padding(.horizontal, 40)
                                .padding(.vertical, 14)
                                .foregroundColor(.white)
                                .background(.purple)
                                .cornerRadius(100)
                        }
                        
                        Button {
                            Task {
                                await viewModel.createShare(for: room)
                                showShareController = true
                            }
                        } label: {
                            Text("Create a new invite")
                        }.foregroundStyle(.purple)
                            .font(.system(.body, design: .rounded))
                            .padding()

                        Spacer()
                    }
                }
                
                // CONVIDADO
                if isShared && !isOwner {
                    VStack {
                        Spacer()
                        Text("You've got a special invitation!").font(.title).padding().bold().multilineTextAlignment(.center)
                        Text("Accept the invite to unlock special features that help keep your love strong and your connection even closer.").multilineTextAlignment(.center).font(.subheadline).padding(.horizontal, 25)
                        Spacer()
                        Image(.carta1).frame(maxWidth: 276, maxHeight: 383)
                            .aspectRatio(1, contentMode: .fit).padding()
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
            
            // LOADING PRA PREPARAR O CONVITE
            if viewModel.sharing {
                Color.black.opacity(0.8).ignoresSafeArea(.all)
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    Text("Preparing Invite...")
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .foregroundStyle(.white)
                }
            }
        }.onReceive(NotificationCenter.default.publisher(for: .didAcceptCloudKitShare)) { _ in
            presentationMode.wrappedValue.dismiss()
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
