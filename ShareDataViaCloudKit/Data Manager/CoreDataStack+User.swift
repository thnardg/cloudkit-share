//
//  CoreDataStack+User.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 11/10/24.
//

import Foundation
import CoreData

// MARK: -- USUÁRIOS
extension CoreDataStack {
    func addUser(isOwner: Bool, to room: Room, id: String, userBirthday: Date, userName: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        // IMPEDE MAIS DE UM DONO NA SALA
        if isOwner {
            fetchRequest.predicate = NSPredicate(format: "room == %@ AND isOwner == true", room)
            do {
                let existingOwners = try context.fetch(fetchRequest)
                if !existingOwners.isEmpty {
                    print("An owner already exists in this room.")
                    return
                }
            } catch {
                print("Error fetching existing owners: \(error)")
                return
            }
        } else {
            // IMPEDE MAIS DE UM SHARED NA SALA
            fetchRequest.predicate = NSPredicate(format: "room == %@ AND isOwner == false", room)
            do {
                let existingSharedUsers = try context.fetch(fetchRequest)
                if !existingSharedUsers.isEmpty {
                    print("A shared user already exists in this room.")
                    return
                }
            } catch {
                print("Error fetching existing shared users: \(error)")
                return
            }
        }
        
        // CRIA O NOVO USUÁRIO
        let user = User(context: context)
        context.perform {
            user.room = room
            user.id = id
            user.isOwner = isOwner
            user.userName = userName
            user.userBirthday = userBirthday
            self.save()
        }
    }
    
    func getUsersCount(for room: Room) -> Int {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "room == %@", room)

            do {
                let users = try context.fetch(fetchRequest)
                return users.count
            } catch {
                print("Failed to fetch users: \(error)")
                return 0
            }
        }
}
