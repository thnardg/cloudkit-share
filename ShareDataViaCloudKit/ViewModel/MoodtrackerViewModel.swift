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
    @Published var todaysUserMood: Moodtracker?
    @Published var todaysPartnerMood: Moodtracker?
    @Published var users: [User] = []
    @Published var buttonStates: [MoodButtonState] = Array(repeating: .none, count: 6)
    
    let moods = ["Happy", "Sad", "Excited", "Angry", "Calm", "Anxious"]

    func fetchUsers(for room: Room, with userUUID: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(User.room), room)
        
        if let fetchedUsers = try? stack.context.fetch(fetchRequest) {
            DispatchQueue.main.async {
                self.users = fetchedUsers
            }
            if let currentUser = fetchedUsers.first(where: { $0.id == userUUID }) {
                fetchTodaysUserMood(for: currentUser)
                fetchTodaysPartnerMood(for: currentUser, in: room)
            }
        }
    }
    
    func fetchTodaysUserMood(for user: User) {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        let fetchRequest: NSFetchRequest<Moodtracker> = Moodtracker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND moodDate >= %@", user, startOfToday as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "moodDate", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        if let fetchedMood = try? stack.context.fetch(fetchRequest).first {
            DispatchQueue.main.async {
                self.todaysUserMood = fetchedMood
            }
        }
    }
    
    func fetchTodaysPartnerMood(for user: User, in room: Room) {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        let fetchRequest: NSFetchRequest<Moodtracker> = Moodtracker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user != %@ AND user.room == %@ AND moodDate >= %@", user, room, startOfToday as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "moodDate", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        if let fetchedMood = try? stack.context.fetch(fetchRequest).first {
            DispatchQueue.main.async {
                self.todaysPartnerMood = fetchedMood
            }
        }
    }
    
    func addOrUpdateMood(for user: User, selectedMood: String) {
        stack.addOrUpdateMood(for: user, selectedMood: selectedMood)
        fetchTodaysUserMood(for: user)
        fetchTodaysPartnerMood(for: user, in: user.room!)
    }
    
    func clearMoodForToday(for user: User) {
        stack.clearMoodForToday(for: user)
        fetchTodaysUserMood(for: user)
        fetchTodaysPartnerMood(for: user, in: user.room!)
    }
    
    func updateButtonStates(selectedIndex: Int, userUUID: String) {
        if buttonStates[selectedIndex] == .selected {
            buttonStates = Array(repeating: .none, count: buttonStates.count)
        } else {
            buttonStates = Array(repeating: .unselected, count: buttonStates.count)
            buttonStates[selectedIndex] = .selected
        }

        if let currentUser = users.first(where: { $0.id == userUUID }) {
            if buttonStates[selectedIndex] == .selected {
                let selectedMood = moods[selectedIndex]
                addOrUpdateMood(for: currentUser, selectedMood: selectedMood)
            } else {
                clearMoodForToday(for: currentUser)
            }
        }
    }
}


enum MoodButtonState {
    case none
    case selected
    case unselected
}
