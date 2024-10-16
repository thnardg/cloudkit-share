//
//  CoreDataStack+Sharing.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import Foundation
import CloudKit
import CoreData


extension CoreDataStack {
    
    // Verifica se o objeto foi compartilhado
    func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == sharedPersistentStore {
                isShared = true
            } else {
                let container = persistentContainer
                do {
                    let shares = try container.fetchShares(matching: [objectID])
                    if shares.first != nil {
                        isShared = true
                    }
                } catch {
                    print("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }

    func isShared(object: NSManagedObject) -> Bool {
        isShared(objectID: object.objectID)
    }

    // Verifica se o objeto pode ser editado
    func canEdit(object: NSManagedObject) -> Bool {
        return persistentContainer.canUpdateRecord(forManagedObjectWith: object.objectID)
    }

    // Verifica se o objeto pode ser deletado
    func canDelete(object: NSManagedObject) -> Bool {
        return persistentContainer.canDeleteRecord(forManagedObjectWith: object.objectID)
    }

    // Verifica se o usuário atual é o dono do sharing
    func isOwner(object: NSManagedObject) -> Bool {
        guard isShared(object: object) else { return false }
        guard let share = try? persistentContainer.fetchShares(matching: [object.objectID])[object.objectID] else {
            print("Get ckshare error")
            return false
        }
        if let currentUser = share.currentUserParticipant, currentUser == share.owner {
            return true
        }
        return false
    }

    // CKShare associado à sala
    func getShare(_ room: Room) -> CKShare? {
        guard isShared(object: room) else { return nil }
        guard let share = try? persistentContainer.fetchShares(matching: [room.objectID])[room.objectID] else {
            print("Get ckshare error")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = room.name
        return share
    }

    // Deleta o CKShare
    func delShare(_ share: CKShare?) async {
        guard let share = share else { return }
        do {
            try await ckContainer.privateCloudDatabase.deleteRecord(withID: share.recordID)
        } catch {
            print("Failed to delete ckshare in icloud, error: \(error)")
        }
    }
}

