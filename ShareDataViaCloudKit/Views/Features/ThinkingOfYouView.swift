//
//  ThinkingOfYouView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import SwiftUI
import CoreData

struct ThinkingOfYouView: View {
    let room: Room

    @AppStorage("userUUID") private var userUUID: String = "" // uuid local
    @StateObject private var viewModel = ThinkingOfYouViewModel()
    @FetchRequest private var users: FetchedResults<User>
    @FetchRequest private var partnerThoughts: FetchedResults<Thought>

    init(room: Room) {
        self.room = room
        
        _users = FetchRequest(entity: User.entity(),
                              sortDescriptors: [],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(User.room), room),
                              animation: .default)

        _partnerThoughts = FetchRequest(entity: Thought.entity(),
                                        sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)],
                                        predicate: NSPredicate(format: "user.room == %@ AND hasThoughtOnPartner == true", room),
                                        animation: .default)
    }

    var body: some View {
        VStack {
            Button("Pensar no parceiro") {
                if let currentUser = users.first(where: { $0.id == userUUID }) {
                    viewModel.addOrUpdateThought(for: currentUser, hasThoughtOnPartner: true)
                }
            }
            .buttonStyle(BorderedButtonStyle())
            .padding()

            if let latestPartnerThought = partnerThoughts.first {
                let partnerName = latestPartnerThought.user?.userName ?? "Parceiro"
                let currentTime = DateFormatter.localizedString(from: latestPartnerThought.timestamp ?? Date(), dateStyle: .none, timeStyle: .medium)
                Text("\(partnerName) pensou em você às \(currentTime)")
                    .padding()
            } else {
                Text("Nenhum pensamento registrado do parceiro.")
                    .padding()
            }
        }
        .padding()
    }
}
