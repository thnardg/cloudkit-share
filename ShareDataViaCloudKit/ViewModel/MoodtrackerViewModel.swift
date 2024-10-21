//
//  MoodtrackerViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 17/10/24.
//

import Foundation
import SwiftUI
import CoreData

class MoodtrackerViewModel: ObservableObject {
    private let stack = CoreDataStack.shared
    @Published var latestPartnerMood: Moodtracker?
    @Published var latestUserMood: Moodtracker?
    @Published var users: [User] = []

    func fetchUsers(for room: Room, with userUUID: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(User.room), room)
        
        if let fetchedUsers = try? stack.context.fetch(fetchRequest) {
            DispatchQueue.main.async {
                self.users = fetchedUsers
            }
            if let currentUser = fetchedUsers.first(where: { $0.id == userUUID }) {
                fetchLatestUserMood(for: currentUser)
                fetchLatestPartnerMood(for: currentUser, in: room)
            }
        }
    }

    func fetchLatestPartnerMood(for user: User, in room: Room) {
        let fetchRequest: NSFetchRequest<Moodtracker> = Moodtracker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user != %@ AND user.room == %@", user, room)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "moodDate", ascending: false)]
        fetchRequest.fetchLimit = 1

        if let fetchedMood = try? stack.context.fetch(fetchRequest).first {
            DispatchQueue.main.async {
                self.latestPartnerMood = fetchedMood
            }
        }
    }

    func fetchLatestUserMood(for user: User) {
        let fetchRequest: NSFetchRequest<Moodtracker> = Moodtracker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "moodDate", ascending: false)]
        fetchRequest.fetchLimit = 1

        if let fetchedMood = try? stack.context.fetch(fetchRequest).first {
            DispatchQueue.main.async {
                self.latestUserMood = fetchedMood
            }
        }
    }

    func addOrUpdateMood(for user: User, selectedMood: String) {
        stack.addOrUpdateMood(for: user, selectedMood: selectedMood)
        fetchLatestUserMood(for: user)
        fetchLatestPartnerMood(for: user, in: user.room!)
    }
}
