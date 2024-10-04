//
//  ContentView.swift
//  ShareDataViaCloudKit
//
//  Created by Thayna Rodrigues on 02/10/24.
//

import CoreData
import SwiftUI

struct NewZoneView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)], animation: .default)
    
    private var notes: FetchedResults<Note>
    
    private let stack = CoreDataStack.shared

    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    }
                    label: {
                        HStack {
                            Text(note.name ?? "")
                            if stack.isShared(object: note) {
                                if stack.isOwner(object: note) {
                                    Image(systemName: "person.2.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            if !canEdit(note) { //se parou de compartilhar
                                Image(systemName: "pencil.slash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .swipeActions {
                        if canEdit(note) {
                            Button(role: .destructive) {
                                withAnimation {
                                    stack.deleteNote(note)
                                }
                            }
                            label: {
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
                            stack.addNote()
                        }
                    }
                    label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("ShareDemo")
        }
    }

    private func canEdit(_ note: Note) -> Bool {
        stack.canEdit(object: note)
    }
}
