import CloudKit
import CoreData
import Foundation
import SwiftUI
import UIKit

// VIEW DAS INFOS COMPARTILHADAS
struct NoteDetailView: View {
    let note: Note // instância da "sala" compartilhada
    @StateObject private var viewModel = NoteDetailViewModel()
    @FetchRequest private var memos: FetchedResults<Memo> // fetch do dado compartilhado
    @FetchRequest private var counters: FetchedResults<Counter> // fetch do dado compartilhado
    @State private var showShareController = false

    // inicializa a sala com as infos que foram compartilhadas nela
    init(note: Note) {
        self.note = note
        
        // faz o fetch das entidades, e determina em qual ordem mostrar as coisas (o que tá determinando o sort é o timestamp, em ordem decrescente)
        _memos = FetchRequest(entity: Memo.entity(),
                              sortDescriptors: [NSSortDescriptor(keyPath: \Memo.timestamp, ascending: false)],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(Memo.note), note), // faz a busca de todos os dados que fazem parte dessa sala específica
                              animation: .default)
        
        _counters = FetchRequest(entity: Counter.entity(),
                                 sortDescriptors: [],
                                 predicate: NSPredicate(format: "%K = %@", #keyPath(Counter.note), note),
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
                        viewModel.incrementCounter(counter, for: note)
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
                ForEach(memos) { memo in
                    Text(memo.text ?? "")
                        .swipeActions {
                            if viewModel.canEdit(note: note) {
                                Button(role: .destructive) {
                                    viewModel.deleteMemo(memo)
                                } label: {
                                    Label("Del", systemImage: "trash")
                                }
                                Button {
                                    viewModel.changeMemoText(memo)
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                .tint(.orange)
                            }
                        }
                }
            }

            if viewModel.canEdit(note: note) {
                HStack {
                    TextField("Write your note here...", text: $viewModel.newMemoText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        withAnimation {
                            viewModel.addMemo(to: note)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                    }
                    .padding()
                    .disabled(viewModel.newMemoText.isEmpty)
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
                        if viewModel.isShared(note: note) {
                            showShareController = true
                        } else {
                            Task.detached {
                                await viewModel.createShare(for: note)
                            }
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .controlGroupStyle(.navigation)
            }
        }
        .navigationTitle(note.name ?? "")
        .sheet(isPresented: $showShareController) {
            let share = CoreDataStack.shared.getShare(note)!
            CloudSharingView(share: share, container: CoreDataStack.shared.ckContainer, note: note)
                .ignoresSafeArea()
        }
        .onAppear {
            if counters.isEmpty {
                viewModel.createCounter(for: note)
            }
        }
    }
}
