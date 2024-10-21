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
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())

        // checa se já tem um mood no dia
        let fetchRequest: NSFetchRequest<Moodtracker> = Moodtracker.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND moodDate >= %@", user, startOfToday as NSDate)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingMood = results.first {
                // update no mood do dia
                context.perform {
                    existingMood.mood = selectedMood
                    existingMood.moodDate = Date()
                    self.save()
                }
            } else {
                // novo mood
                context.perform {
                    let newMood = Moodtracker(context: self.context)
                    newMood.user = user
                    newMood.mood = selectedMood
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

