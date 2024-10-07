//
//  NewZoneViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 04/10/24.
//

import Foundation

class NewZoneViewModel: ObservableObject {
    private let stack = CoreDataStack.shared

    func addNote() {
        stack.addNote()
    }

    func deleteNote(_ note: Note) {
        stack.deleteNote(note)
    }

    func canEdit(_ note: Note) -> Bool {
        return stack.canEdit(object: note) 
    }

    func isOwner(_ note: Note) -> Bool {
        return stack.isOwner(object: note) // checa se vc é o dono da sala criada
    }

    func isShared(_ note: Note) -> Bool {
        return stack.isShared(object: note) // checa se a sala tá compartilhada
    }
}
