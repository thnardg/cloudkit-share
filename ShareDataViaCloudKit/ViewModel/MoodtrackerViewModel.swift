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
    
    @Published var users: [User] = []
    @Published var buttonStates: [MoodButtonState] = Array(repeating: .none, count: Mood.allCases.count)

    func fetchUsers(for room: Room, with userUUID: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(User.room), room)
        
        if let fetchedUsers = try? stack.context.fetch(fetchRequest) {
            DispatchQueue.main.async {
                self.users = fetchedUsers
            }
        }
    }
    
    func addOrUpdateMood(for user: User, selectedMood: Mood) {
            stack.addOrUpdateMood(for: user, selectedMood: selectedMood.rawValue)
        }
    
    func clearMoodForToday(for user: User) {
        stack.clearMoodForToday(for: user)
    }
    
    func updateButtonStates(selectedMood: Mood, userUUID: String) {
        buttonStates = Array(repeating: .unselected, count: buttonStates.count)

        var selectedIndex: Int?

        if let index = Mood.allCases.firstIndex(of: selectedMood) {
            selectedIndex = index
            buttonStates[selectedIndex!] = .selected
        }

        if let currentUser = users.first(where: { $0.id == userUUID }) {
            if let selectedIndex = selectedIndex, buttonStates[selectedIndex] == .selected {
                addOrUpdateMood(for: currentUser, selectedMood: selectedMood)
            }
        }
    }
}

enum MoodButtonState {
    case none
    case selected
    case unselected
}

enum Mood: String, CaseIterable {
    case happy = "Happy"
    case sad = "Sad"
    case excited = "Excited"
    case angry = "Angry"
    case calm = "Calm"
    case anxious = "Anxious"
    
    var imageName: String {
        switch self {
        case .happy:
            return "cloud.sun.circle.fill"
        case .sad:
            return "cloud.drizzle.circle.fill"
        case .excited:
            return "cloud.snow.circle.fill"
        case .angry:
            return "cloud.moon.bolt.circle.fill"
        case .calm:
            return "cloud.circle.fill"
        case .anxious:
            return "cloud.sleet.circle.fill"
        }
    }
}
