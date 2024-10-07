import CloudKit
import CoreData
import Foundation
import SwiftUI
import UIKit

// VIEW DAS INFOS COMPARTILHADAS
struct NoteDetailView: View {
    let room: Room // instância da "sala" compartilhada
    @StateObject private var viewModel = NoteDetailViewModel()
    @FetchRequest private var notes: FetchedResults<Note> // fetch do dado compartilhado
    @FetchRequest private var counters: FetchedResults<Counter> // fetch do dado compartilhado
    @State private var showShareController = false

    // inicializa a sala com as infos que foram compartilhadas nela
    init(room: Room) {
        self.room = room
        
        // faz o fetch das entidades, e determina em qual ordem mostrar as coisas (o que tá determinando o sort é o timestamp, em ordem decrescente)
        _notes = FetchRequest(entity: Note.entity(),
                              sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(Note.room), room), // faz a busca de todos os dados que fazem parte dessa sala específica
                              animation: .default)
        
        _counters = FetchRequest(entity: Counter.entity(),
                                 sortDescriptors: [],
                                 predicate: NSPredicate(format: "%K = %@", #keyPath(Counter.room), room),
                                 animation: .default)
    }

    var body: some View {
        VStack {
            if let counter = counters.first { //checa se existe um contador
                HStack {
                    VStack{
                        Text("User 1: \(counter.userOneCount)")
                            .font(.headline)
                            .padding()
                        Text("User 2: \(counter.userTwoCount)")
                            .font(.headline)
                            .padding()

                    }

                    Button(action: {
                        viewModel.incrementCounter(counter, for: room)
                    }) {
                        Text("Counted")
                            .font(.system(size: 24))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            
            List {
                ForEach(notes) { note in
                    Text(note.text ?? "")
                        .swipeActions {
                            if viewModel.canEdit(room: room) {
                                Button(role: .destructive) {
                                    viewModel.deleteNote(note)
                                } label: {
                                    Label("Del", systemImage: "trash")
                                }
                                Button {
                                    viewModel.changeNoteText(note)
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                .tint(.orange)
                            }
                        }
                }
            }

            if viewModel.canEdit(room: room) {
                HStack {
                    TextField("Write your note here...", text: $viewModel.newNoteText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        withAnimation {
                            viewModel.addNote(to: room)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                    }
                    .padding()
                    .disabled(viewModel.newNoteText.isEmpty)
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem {
                HStack {
                    if viewModel.sharing {
                        ProgressView()
                    }

                    Button {
                        if viewModel.isShared(room: room) {
                            showShareController = true
                        } else {
                            Task.detached {
                                await viewModel.createShare(for: room)
                            }
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .controlGroupStyle(.navigation)
            }
        }
        .navigationTitle(room.name ?? "")
        .sheet(isPresented: $showShareController) {
            let share = CoreDataStack.shared.getShare(room)!
            CloudSharingView(share: share, container: CoreDataStack.shared.ckContainer, room: room)
                .ignoresSafeArea()
        }
        .onAppear {
            if counters.isEmpty {
                viewModel.createCounter(for: room)
            }
        }
    }
}
