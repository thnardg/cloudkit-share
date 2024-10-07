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
        @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)], animation: .default)
        private var notes: FetchedResults<Note>
        @StateObject private var viewModel = NewZoneViewModel()
        @State private var id = UUID()
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(notes) { note in
                        NavigationLink {
                            NoteDetailView(note: note)
                        } label: {
                            HStack {
                                Text(note.name ?? "")
                                if viewModel.isShared(note) {
                                    if viewModel.isOwner(note) {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                                if !viewModel.canEdit(note) {
                                    Image(systemName: "pencil.slash")
                                        .foregroundColor(.red)
                                }
                            }
                            .id(id)
                        }
                        .swipeActions {
                            if viewModel.canEdit(note) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.deleteNote(note)
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
                                viewModel.addNote()
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
