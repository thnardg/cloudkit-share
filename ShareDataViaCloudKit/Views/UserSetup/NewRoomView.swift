//
//  ContentView.swift
//  ShareDataViaCloudKit
//
//  Created by Thayna Rodrigues on 02/10/24.
//

import SwiftUI
import CoreData

struct NewRoomView: View {
    @StateObject private var viewModel = NewRoomViewModel()
    
    @FetchRequest(entity: Room.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Room.timestamp, ascending: false)], animation: .default)
    private var rooms: FetchedResults<Room>
    
    @State private var id = UUID()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(rooms) { room in
                        NavigationLink {
                            ShareRoomView(room: room)
                        } label: {
                            HStack {
                                if viewModel.isShared(room) {
                                    if viewModel.isOwner(room) {
                                        Image(systemName: "arrow.up.heart.fill")
                                            .foregroundColor(.pink)
                                    } else {
                                        Image(systemName: "arrow.down.heart.fill")
                                            .foregroundColor(.pink)
                                    }
                                }
                                if !viewModel.canEdit(room) {
                                    Image(systemName: "heart.slash.fill")
                                        .foregroundColor(.red)
                                }
                                Text(room.name ?? "")
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
                .navigationTitle("Widgetogether")
                .onAppear { id = UUID() }

                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            viewModel.addRoom()
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create New Room")
                        }
                        .padding()
                        .foregroundColor(.white).bold()
                        .background(Color.purple)
                        .cornerRadius(100)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    NewRoomView()
}
