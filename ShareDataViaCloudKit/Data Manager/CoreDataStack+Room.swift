//
//  CoreDataStack+Notes.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 11/10/24.
//

import Foundation
import CoreData


// MARK: -- SALA
extension CoreDataStack {
    func addRoom() {
        let room = Room(context: context)
        context.perform {
            room.name = "SALA \(Int.random(in: 1000...2000))"
            room.timestamp = Date()
            self.save()
        }
    }

    func deleteRoom(_ room: Room) {
        context.perform {
            self.context.delete(room)
            self.save()
        }
    }
}
