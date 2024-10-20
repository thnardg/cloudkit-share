//
//  NewUserView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 10/10/24.
//

import SwiftUI

struct NewUserView: View {
    let room: Room
    @State private var userName: String = ""
    @State private var userBirthday: Date = Date()
    
    @State private var showUserInfo: Bool = false

    private let stack = CoreDataStack.shared

    @FetchRequest private var users: FetchedResults<User>
    
    // Salva a id do usuário atual localmente
    @AppStorage("userUUID") private var userUUID: String = ""

    init(room: Room) {
        self.room = room
        
        _users = FetchRequest(entity: User.entity(),
                              sortDescriptors: [],
                              predicate: NSPredicate(format: "%K = %@", #keyPath(User.room), room),
                              animation: .default)
    }
    
    var body: some View {
        VStack {
            Spacer()

            if !users.isEmpty {
                List(users, id: \.self) { user in
                    VStack(alignment: .leading) {
                        Text("Nome: \(user.userName ?? "")")
                        Text("Aniversário: \(user.userBirthday ?? Date())")
                    }
                }
            }
            
            TextField("Seu nome", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            DatePicker("Aniversário", selection: $userBirthday, displayedComponents: .date)
                .padding()
            
            Button("Salvar") {
                showUserInfo = true

                // Gera uma uuid nova se não existir uma
                if userUUID.isEmpty {
                    userUUID = UUID().uuidString
                }

                // Cria o usuário novo passando a uuid local pro CoreData
                if stack.isOwner(object: room) {
                    stack.addUser(isOwner: true, to: room, id: userUUID, userBirthday: userBirthday, userName: userName)
                } else {
                    stack.addUser(isOwner: false, to: room, id: userUUID, userBirthday: userBirthday, userName: userName)
                }
            }
            .padding()

            if users.count >= 2 {
                NavigationLink(destination: MainTabView(room: room)) {
                    Text("Go to Home")
                        .buttonStyle(BorderedButtonStyle())
                }
                .padding()
            }
            Spacer()
        }
        .padding()
    }
}
