//
//  IndividualMoodtrackerView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 24/10/24.
//

import SwiftUI

struct IndividualMoodtrackerView: View {
    let room: Room
    var isPartner: Bool

    @AppStorage("userUUID") private var userUUID: String = ""

    @FetchRequest private var users: FetchedResults<User>
    @FetchRequest private var partnersMood: FetchedResults<Moodtracker>
    @FetchRequest private var myMood: FetchedResults<Moodtracker>

    init(room: Room, isPartner: Bool) {
        self.room = room
        self.isPartner = isPartner
        
        // fetch dos usuários
        _users = FetchRequest(entity: User.entity(),
                              sortDescriptors: [],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(User.room), room),
                              animation: .default)

        // fetch do mood do parceiro
        _partnersMood = FetchRequest(entity: Moodtracker.entity(),
                                     sortDescriptors: [NSSortDescriptor(key: "moodDate", ascending: false)],
                                     predicate: NSPredicate(format: "user.room == %@ AND user.id != %@", room, UserDefaults.standard.string(forKey: "userUUID") ?? ""),
                                     animation: .default
        )
        
        // fetch do mood do usuário
        _myMood = FetchRequest(entity: Moodtracker.entity(),
                               sortDescriptors: [NSSortDescriptor(key: "moodDate", ascending: false)],
                               predicate: NSPredicate(format: "user.room == %@ AND user.id == %@", room, UserDefaults.standard.string(forKey: "userUUID") ?? ""),
                               animation: .default
        )
    }

    var body: some View {
        let mood = isPartner ? partnersMood.first : myMood.first // define qual o mood mostrar no card
        let moodEnum = Mood(rawValue: mood?.mood ?? "")

        HStack {
            Spacer()
            VStack {
                Text(isPartner ? (mood?.user?.userName ?? "Partner") : (mood?.user?.userName ?? "Me"))
                    .font(.system(size: 11))
                    .textCase(.uppercase)
                    .foregroundStyle(.gray)
                
                Image(systemName: moodEnum?.imageName ?? "circle.dotted")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 56)
                    .foregroundColor(.black)
                    .padding(4)
                
                Text(mood?.mood ?? "No Mood Yet")
                    .foregroundStyle(.black)
                    .font(.footnote).bold()
                
                if let timestamp = mood?.moodDate {
                    Text(timestamp.formattedForDisplay())
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .padding(.top, 4)
                } else {
                    Text("No Data")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .padding(.top, 4)
                }
            }
            Spacer()
        }
    }
}
