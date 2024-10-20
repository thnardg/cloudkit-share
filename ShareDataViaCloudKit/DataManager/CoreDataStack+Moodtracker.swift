//
//  CoreDataStack+Moodtracker.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 17/10/24.
//

import Foundation
import CoreData

// MARK: -- Moodtracker
extension CoreDataStack {
    func addOrUpdateMood(for user: User, selectedMood: String) {
        // Define the start of today
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())

        // Fetch request to check if a mood exists for today
        let fetchRequest: NSFetchRequest<Moodtracker> = Moodtracker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND moodDate >= %@", user, startOfToday as NSDate)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingMood = results.first {
                // Update the existing mood
                context.perform {
                    existingMood.mood = selectedMood  // Update the mood
                    existingMood.moodDate = Date()    // Update the timestamp
                    self.save()
                }
            } else {
                // Create a new mood entry
                context.perform {
                    let newMood = Moodtracker(context: self.context)
                    newMood.user = user
                    newMood.mood = selectedMood      // Set the mood
                    newMood.moodDate = Date()
                    newMood.id = UUID()
                    self.save()
                }
            }
        } catch {
            print("Failed to fetch mood for today: \(error)")
        }
    }
}

