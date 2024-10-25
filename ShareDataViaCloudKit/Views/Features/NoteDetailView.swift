import CloudKit
import CoreData
import Foundation
import SwiftUI
import UIKit

// VIEW DAS INFOS COMPARTILHADAS
struct NoteDetailView: View {
    let room: Room // instância da "sala" compartilhada
    @StateObject private var viewModel = NoteDetailViewModel()
    @StateObject private var sharingManager = ShareRoomViewModel()
    @FetchRequest private var notes: FetchedResults<Note> // fetch do dado compartilhado

    // inicializa a sala com as infos que foram compartilhadas nela
    init(room: Room) {
        self.room = room
        
        // faz o fetch das entidades, e determina em qual ordem mostrar as coisas (o que tá determinando o sort é o timestamp, em ordem decrescente)
        _notes = FetchRequest(entity: Note.entity(),
                              sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(Note.room), room), // faz a busca de todos os dados que fazem parte dessa sala específica
                              animation: .default)
    }

    var body: some View {
        VStack {
            //ThinkingOfYouView(room: room)
            List {
                ForEach(notes) { note in
                    Text(note.text ?? "")
                        .swipeActions {
                            if sharingManager.canEdit(room: room) {
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

            if sharingManager.canEdit(room: room) {
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
        .navigationTitle(room.name ?? "")
    }
}
