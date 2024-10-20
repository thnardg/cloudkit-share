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

    @AppStorage("userUUID") private var userUUID: String = "" //uuid local
    @StateObject private var viewModel = ThinkingOfYouViewModel()
    @FetchRequest private var users: FetchedResults<User>

    init(room: Room) {
        self.room = room
        
        _users = FetchRequest(entity: User.entity(),
                              sortDescriptors: [],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(User.room), room),
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

            // mostra se o parceiro pensou em você
            if let latestPartnerThought = viewModel.latestPartnerThought {
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
        .onAppear {
            // atualiza o pensamento mais recente do parceiro
            if let currentUser = users.first(where: { $0.id == userUUID }) {
                viewModel.fetchLatestPartnerThought(for: currentUser, in: room)
            }
        }
    }
}
