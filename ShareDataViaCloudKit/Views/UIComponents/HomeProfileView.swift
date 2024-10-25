//
//  HomeProfileView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 25/10/24.
//

import SwiftUI

struct HomeProfileView: View {
    let room: Room
    
    @AppStorage("userUUID") private var userUUID: String = "" // uuid local
    
    @FetchRequest private var users: FetchedResults<User>
    
    init(room: Room) {
        self.room = room
        
        _users = FetchRequest(entity: User.entity(),
                              sortDescriptors: [],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(User.room), room),
                              animation: .default)
    }
    
    var body: some View {
        HStack {
            Circle()
                .scaledToFit()
                .frame(width: 50)
                .overlay {
                    //TODO: foto do perfil do usuário
                    Image(systemName: "moon.stars.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                }
                .foregroundStyle(.white)
            
            VStack(alignment: .leading) {
                let userName = users.first(where: { $0.id == userUUID })?.userName ?? "You"
                let partnerName = users.first(where: { $0.id != userUUID })?.userName ?? "your partner"
                
                Text(userName)
                    .font(.subheadline)
                    .bold()
                
                Text("Ready to make today special with \(partnerName)?")
                    .font(.caption)
            }
            .frame(width: 165)
            
            Spacer()
            
            // TODO: Botões de notificação e edição dos widgets
            Image(systemName: "bell.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
        }
        .padding()
    }
}
