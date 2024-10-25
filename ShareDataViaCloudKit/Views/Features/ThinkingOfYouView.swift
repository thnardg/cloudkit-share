//
//  ThinkingOfYouView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import SwiftUI
import CoreData
/*
 
struct ThinkingOfYouView: View {
    
    let room: Room

    @AppStorage("userUUID") private var userUUID: String = "" //uuid local
    @StateObject private var viewModel = ThinkingOfYouViewModel()

    @FetchRequest private var users: FetchedResults<User>
    @FetchRequest private var partnersThoughts: FetchedResults<Thought>

    init(room: Room) {
        self.room = room
        
        _users = FetchRequest(entity: User.entity(),
                              sortDescriptors: [],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(User.room), room),
                              animation: .default)
        
        _partnersThoughts = FetchRequest(entity: Thought.entity(),
                                         sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)],
                                         predicate: NSPredicate(format: "user.room == %@ AND user.id != %@ AND hasThoughtOnPartner == true", room, UserDefaults.standard.string(forKey: "userUUID") ?? ""),
                                         animation: .default
        )
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

            // Mostra se o parceiro pensou em você
            if let latestPartnerThought = partnersThoughts.first {
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
*/
    
import SwiftUI
import CoreData

struct ThinkingOfYouView: View {
    let room: Room

    @AppStorage("userUUID") private var userUUID: String = "" //uuid local
    @StateObject private var viewModel = ThinkingOfYouViewModel()

    @FetchRequest private var users: FetchedResults<User>
    @FetchRequest private var partnersThoughts: FetchedResults<Thought>

    init(room: Room) {
        self.room = room
        
        _users = FetchRequest(entity: User.entity(),
                              sortDescriptors: [],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(User.room), room),
                              animation: .default)
        
        _partnersThoughts = FetchRequest(entity: Thought.entity(),
                                         sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)],
                                         predicate: NSPredicate(format: "user.room == %@ AND user.id != %@ AND hasThoughtOnPartner == true", room, UserDefaults.standard.string(forKey: "userUUID") ?? ""),
                                         animation: .default
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Thinking of You").bold()
            VStack(alignment: .leading) {
                if let latestPartnerThought = partnersThoughts.first {
                    let partnerName = latestPartnerThought.user?.userName ?? "Parceiro"
                    Text("\(partnerName) is thinking about you!").font(.subheadline).bold()
                    Text(latestPartnerThought.timestamp?.formattedForDisplay() ?? "Couldn't find the time").font(.caption2).italic().foregroundStyle(.gray)
                }
                Spacer()

                Button {
                    if let currentUser = users.first(where: { $0.id == userUUID }) {
                        viewModel.addOrUpdateThought(for: currentUser, hasThoughtOnPartner: true)
                    }
                } label: {
                    Text("Think of Them")

                }
                .font(.system(size: 14))
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white).bold()
                .background(Color.black)
                .cornerRadius(100)
            }.padding(16)
             .background(.white)
            .cornerRadius(22)
            .frame(width: 158, height: 158)
        }
    }
}

