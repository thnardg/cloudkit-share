//
//  NoteDetailViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 04/10/24.
//

import Foundation
import SwiftUI
import CloudKit

class NoteDetailViewModel: ObservableObject {
    private let stack = CoreDataStack.shared
    @Published var sharing = false
    @Published var newNoteText: String = ""

    func addNote(to room: Room) {
        if !newNoteText.isEmpty {
            stack.addNote(room, text: newNoteText)
            newNoteText = ""
        }
    }

    func deleteNote(_ note: Note) {
        stack.deleteNote(note)
    }

    func changeNoteText(_ note: Note) {
        stack.changeNoteText(note)
    }

    func incrementCounter(_ counter: Counter, for room: Room) {
        if stack.isOwner(object: room) {
            counter.userOneCount += 1
        } else {
            counter.userTwoCount += 1
        }
        self.stack.incrementCounter(counter)
    }


        func createCounter(for room: Room) {
            stack.addCounter(to: room)
        }


    
    func createShare(for room: Room) async {
        sharing = true
        do {
            let (_, share, _) = try await stack.persistentContainer.share([room], to: nil)
            share[CKShare.SystemFieldKey.title] = room.name
        } catch {
            print("Failed to create share")
            sharing = false
        }
        sharing = false
    }

    func isShared(room: Room) -> Bool {
        return stack.isShared(object: room)
    }

    func canEdit(room: Room) -> Bool {
        return stack.canEdit(object: room)
    }
}
