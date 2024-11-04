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
    
    @State private var createdRoom: Room? = nil
    @State private var isNavigatingToShareRoom = false  // controla a navegação
    @State private var showDeleteConfirmation = false   // deletar a sala

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // mostra a sala se existir uma
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
                
                // cria e navega pra sala
                Button(action: {
                    withAnimation {
                        if rooms.isEmpty { // checa se nenhuma sala existe
                            viewModel.addRoom()
                            
                            // força a view a recarregar
                            DispatchQueue.main.async {
                                createdRoom = rooms.first // faz um update na ciew
                                isNavigatingToShareRoom = true // dá o trigger na navegação
                            }
                        } else {
                            createdRoom = rooms.first      // mostra a sala atual
                            isNavigatingToShareRoom = true // trigger na navegação
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
                
                // determina o destino da navegação
                .navigationDestination(isPresented: $isNavigatingToShareRoom) {
                        ShareRoomView()
                    
                }
                
                // MARK: -- DELETA AS SALAS PRA TESTEA
                 Button(action: {
                     showDeleteConfirmation = true
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
                         deleteAllRooms()
                     }
                 }
            }
            .navigationTitle("Widgetogether")
        }
    }
    // função pra deletar a sala (Teste)
    private func deleteAllRooms() {
        for room in rooms {
            viewModel.deleteRoom(room)
        }
    }
}

#Preview {
    NewRoomView()
}
