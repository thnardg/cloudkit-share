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
                // MARK: -- DELETA AS SALAS PRA TESTEA
                 Button(action: {
                     deleteAllRooms()
                 }) {
                     Text("Delete All Rooms").foregroundStyle(.purple)
                 }
                Spacer()
                Text("Discover a new way to strenghten your relationship")
                    .font(.system(.title, design: .rounded))
                    .bold()
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text("Express affection daily in an easy and fun way with our exclusive widgets.")
                    .font(.system(.subheadline, design: .rounded))
                    .padding(.bottom, 40)
                    .multilineTextAlignment(.center)

                OnboardingButton(title: "Continue") {
                    if rooms.isEmpty {
                        viewModel.addRoom()
                        
                        // força a view a recarregar
                        DispatchQueue.main.async {
                            createdRoom = rooms.first
                            isNavigatingToShareRoom = true // dá o trigger na navegação
                        }
                    } else {
                        createdRoom = rooms.first // a sala atual
                        isNavigatingToShareRoom = true // trigger na navegação
                    }
                }.padding(.bottom, 40)
                // determina o destino da navegação
                .navigationDestination(isPresented: $isNavigatingToShareRoom) {
                        ShareRoomView()
                    
                }
            }
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
