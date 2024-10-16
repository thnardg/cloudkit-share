//
//  CoreDataStack+Notes.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 11/10/24.
//

import Foundation
import CoreData


// MARK: -- RECADOS
extension CoreDataStack {
    func addNote(_ room: Room, text: String) {
        let note = Note(context: context)
        context.perform {
            note.room = room
            note.text = text
            note.timestamp = Date()
            self.save()
        }
    }

    func deleteNote(_ note: Note) {
        context.perform {
            self.context.delete(note)
            self.save()
        }
    }

    func changeNoteText(_ note: Note) {
        context.perform {
            let text = note.text ?? ""
            note.text = text.appending(String(" \(Int.random(in: 0...9))"))
            self.save()
        }
    }
}
