import SwiftUI
import CoreData

struct NewRoomView: View {
    @StateObject private var viewModel = NewRoomViewModel()
    
    @FetchRequest(
        entity: Room.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Room.timestamp, ascending: false)],
        animation: .default
    )
    private var rooms: FetchedResults<Room>
    
    @State private var createdRoom: Room? = nil         // Track the created room
    @State private var isNavigatingToShareRoom = false  // Control navigation state
    @State private var showDeleteConfirmation = false   // Control the delete confirmation alert

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Display existing room if available
                if let room = createdRoom ?? rooms.first {
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
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                } else {
                    Text("No room created yet")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Create Room or Go to Room Button
                Button(action: {
                    withAnimation {
                        if rooms.isEmpty { // Check if there are no existing rooms
                            viewModel.addRoom()            // Create a room
                            
                            // Force refresh the createdRoom
                            DispatchQueue.main.async {
                                createdRoom = rooms.first // Make sure to update after the addRoom
                                isNavigatingToShareRoom = true // Trigger navigation
                            }
                        } else {
                            createdRoom = rooms.first      // Get the existing room
                            isNavigatingToShareRoom = true // Trigger navigation
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text(rooms.isEmpty ? "Create New Room" : "Go to Room")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .bold()
                    .background(Color.purple)
                    .cornerRadius(100)
                    .padding(.horizontal)
                }

                .padding(.bottom, 30)
                
                // Trigger navigation for ShareRoomView
                .navigationDestination(isPresented: $isNavigatingToShareRoom) {
                    if let room = createdRoom {
                        ShareRoomView(room: room)
                    }
                }
                
                // Delete All Rooms Button
                 Button(action: {
                     showDeleteConfirmation = true // Show confirmation alert
                 }) {
                     Text("Delete All Rooms")
                         .padding()
                         .foregroundColor(.white)
                         .bold()
                         .background(Color.red)
                         .cornerRadius(100)
                         .padding(.horizontal)
                 }
                 .alert("Are you sure you want to delete all rooms?", isPresented: $showDeleteConfirmation) {
                     Button("Cancel", role: .cancel) { }
                     Button("Delete", role: .destructive) {
                         deleteAllRooms() // Call method to delete all rooms
                     }
                 }
            }
            .navigationTitle("Widgetogether")
        }
    }
    // Function to delete all rooms
    private func deleteAllRooms() {
        for room in rooms {
            viewModel.deleteRoom(room) // Delete each room using the existing deleteRoom method
        }
    }
}

#Preview {
    NewRoomView()
}
