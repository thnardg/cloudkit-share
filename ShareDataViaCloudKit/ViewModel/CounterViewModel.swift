//
//  CounterViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import Foundation
import CoreData

class ThoughtViewModel: ObservableObject {
    private let stack = CoreDataStack.shared
    @Published var latestPartnerThought: Counter?

    // Função para buscar o pensamento mais recente do parceiro na mesma sala
    func fetchLatestPartnerThought(for user: User, in room: Room) {
        let fetchRequest: NSFetchRequest<Counter> = Counter.fetchRequest()
        // Filtrar pensamentos de outros usuários na mesma sala
        fetchRequest.predicate = NSPredicate(format: "user != %@ AND user.room == %@ AND hasThoughtOnPartner == true", user, room)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1

        if let fetchedThought = try? stack.context.fetch(fetchRequest).first {
            DispatchQueue.main.async {
                self.latestPartnerThought = fetchedThought
            }
        }
    }

    // Função para adicionar ou atualizar seu próprio pensamento
    func addOrUpdateThought(for user: User, hasThoughtOnPartner: Bool) {
        stack.addOrUpdateThought(for: user, hasThoughtOnPartner: hasThoughtOnPartner)
        fetchLatestPartnerThought(for: user, in: user.room!)  // Recarrega o pensamento mais recente do parceiro na mesma sala
    }
}
