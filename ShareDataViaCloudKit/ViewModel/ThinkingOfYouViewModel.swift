//
//  ThinkingOfYouViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import Foundation
import CoreData

class ThinkingOfYouViewModel: ObservableObject {
    private let stack = CoreDataStack.shared
    @Published var latestPartnerThought: Thought?

    // Busca o pensamento mais recente do parceiro na mesma sala
    func fetchLatestPartnerThought(for user: User, in room: Room) {
        let fetchRequest: NSFetchRequest<Thought> = Thought.fetchRequest()
        // filtra se o usuário não é o usuário atual, se está na mesma sala, e se pensou no parceiro alguma vez
        fetchRequest.predicate = NSPredicate(format: "user != %@ AND user.room == %@ AND hasThoughtOnPartner == true", user, room)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1

        if let fetchedThought = try? stack.context.fetch(fetchRequest).first {
            DispatchQueue.main.async {
                self.latestPartnerThought = fetchedThought
            }
        }
    }

    // adiciona ou cria um novo pensamento
    func addOrUpdateThought(for user: User, hasThoughtOnPartner: Bool) {
        stack.addOrUpdateThought(for: user, hasThoughtOnPartner: hasThoughtOnPartner)
        fetchLatestPartnerThought(for: user, in: user.room!)  // recarrega o pensamento mais recente do parceiro na mesma sala
    }
}
