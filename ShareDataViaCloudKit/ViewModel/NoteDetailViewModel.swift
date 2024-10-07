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
}
