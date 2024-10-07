//
//  ContentView.swift
//  ShareDataViaCloudKit
//
//  Created by Thayna Rodrigues on 02/10/24.
//

import SwiftUI
import CoreData

// Essa View lida com as "Salas" compartilhadas
struct NewZoneView: View {
        @FetchRequest(entity: Room.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Room.timestamp, ascending: false)], animation: .default)
        private var rooms: FetchedResults<Room>
        @StateObject private var viewModel = NewZoneViewModel()
        @State private var id = UUID()
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(rooms) { room in
                        NavigationLink {
                            ShareRoomView(room: room)
                        } label: {
                            HStack {
                                Text(room.name ?? "")
                                if viewModel.isShared(room) {
                                    if viewModel.isOwner(room) {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                                if !viewModel.canEdit(room) {
                                    Image(systemName: "pencil.slash")
                                        .foregroundColor(.red)
                                }
                            }
                            .id(id)
                        }
                        .swipeActions {
                            if viewModel.canEdit(room) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.deleteRoom(room)
                                    }
                                } label: {
                                    Label("Del", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            withAnimation {
                                viewModel.addRoom()
                            }
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationTitle("ShareDemo")
                .onAppear { id = UUID() }
            }
        }
    }
