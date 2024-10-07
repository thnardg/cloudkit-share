//
//  NewZoneViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 04/10/24.
//

import Foundation

class NewRoomViewModel: ObservableObject {
    private let stack = CoreDataStack.shared

    func addRoom() {
        stack.addRoom()
    }

    func deleteRoom(_ room: Room) {
        stack.deleteRoom(room)
    }

    func canEdit(_ room: Room) -> Bool {
        return stack.canEdit(object: room)
    }

    func isOwner(_ room: Room) -> Bool {
        return stack.isOwner(object: room) // checa se vc é o dono da sala criada
    }

    func isShared(_ room: Room) -> Bool {
        return stack.isShared(object: room) // checa se a sala tá compartilhada
    }
}
