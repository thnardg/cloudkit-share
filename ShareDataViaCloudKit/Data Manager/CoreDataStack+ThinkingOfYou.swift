//
//  CoreDataStack+Counter.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 11/10/24.
//

import Foundation
import CoreData

// MARK: -- PENSEI EM VOCÊ
extension CoreDataStack {
    func addOrUpdateThought(for user: User, hasThoughtOnPartner: Bool) {
        // Verifica se há um pensamento existente para o usuário atual
        let fetchRequest: NSFetchRequest<Counter> = Counter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@ AND hasThoughtOnPartner == %@", user, NSNumber(value: hasThoughtOnPartner))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        if let existingThought = try? context.fetch(fetchRequest).first {
            // Atualiza o pensamento existente
            context.perform {
                existingThought.timestamp = Date()
                self.save()
            }
        } else {
            // Cria um novo pensamento se nenhum for encontrado
            let newThought = Counter(context: context)
            context.perform {
                newThought.user = user
                newThought.timestamp = Date()
                newThought.hasThoughtOnPartner = hasThoughtOnPartner
                self.save()
            }
        }
    }
}
