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
    func addNewMood(for user: User) {
        // Cria um novo mood
        let mood = Moodtracker(context: context)
        context.perform {
            mood.user = user
            mood.moodDate = Date()
            mood.id = UUID()
            self.save()
        }
    }
}

