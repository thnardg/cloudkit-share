//
//  ShareRoomViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import Foundation
import CloudKit

class ShareRoomViewModel: ObservableObject {
    private let stack = CoreDataStack.shared
    @Published var sharing = false
    
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
