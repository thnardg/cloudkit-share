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
    @FetchRequest private var partnersThoughts: FetchedResults<Thought>
    @FetchRequest private var usersThoughts: FetchedResults<Thought>
    
    init(room: Room) {
        self.room = room
        
        _users = FetchRequest(entity: User.entity(),
                              sortDescriptors: [],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(User.room), room),
                              animation: .default)
        
        _partnersThoughts = FetchRequest(entity: Thought.entity(),
                                         sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)],
                                         predicate: NSPredicate(format: "user.room == %@ AND user.id != %@ AND hasThoughtOnPartner == true", room, UserDefaults.standard.string(forKey: "userUUID") ?? ""),
                                         animation: .default)
        
        _usersThoughts = FetchRequest(entity: Thought.entity(),
                                      sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)],
                                      predicate: NSPredicate(format: "user.room == %@ AND user.id == %@ AND hasThoughtOnPartner == true", room, UserDefaults.standard.string(forKey: "userUUID") ?? ""),
                                      animation: .default)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let latestPartnerThought = partnersThoughts.first {
                // se o parceiro pensou
                let partnerName = latestPartnerThought.user?.userName ?? "Parceiro"
                Text("\(partnerName) is thinking about you!")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundStyle(.black)
                Text(latestPartnerThought.timestamp?.formattedForDisplay() ?? "Couldn't find the time")
                    .font(.caption2)
                    .italic()
                    .foregroundStyle(.gray)
            } else if let latestUserThought = usersThoughts.first {
                // se eu pensei e o parceiro não
                Text("We'll let your partner know you're thinking about them")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundStyle(.black)
            } else {
                // default
                Text("Let your partner know you're thinking about them")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            HomeWidgetButton(title: "Think of Them", action: {
                if let currentUser = users.first(where: { $0.id == userUUID }) {
                    viewModel.addOrUpdateThought(for: currentUser, hasThoughtOnPartner: true)
                }
            })
        }
        .padding(16)
    }
}
