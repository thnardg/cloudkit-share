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
            HStack {
                if !users.isEmpty {
                    ForEach(users, id: \.self) { user in
                        UserCard(user: user)
                    }
                }
            }.padding()
        }.padding(.vertical)
        

            VStack {
                TextField("Seu nome", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                DatePicker("Aniversário", selection: $userBirthday, displayedComponents: .date)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .bold()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                
                Button {
                    showUserInfo = true
                    if userUUID.isEmpty {
                        userUUID = UUID().uuidString
                    }
                    
                    if stack.isOwner(object: room) {
                        stack.addUser(isOwner: true, to: room, id: userUUID, userBirthday: userBirthday, userName: userName)
                    } else {
                        stack.addUser(isOwner: false, to: room, id: userUUID, userBirthday: userBirthday, userName: userName)
                    }
                } label: {
                    Image(systemName: "plus")
                    Text("Salvar")
                }
                .foregroundColor(.purple).bold()
                .padding()
                Spacer()
                
            }
            Spacer()
        
        //PERMITE ENTRAR NO APP MESMO SEM TER 2 USERS (mas não mais do que 2 ou menos que 1
            VStack {
                if users.count == 2 || users.count == 1 {
                        NavigationLink(destination: MainTabView(room: room)) {
                            Text("Go to shared room")
                            Image(systemName: "arrow.right")
                        }.padding()
                            .foregroundColor(.white).bold()
                            .background(Color.purple)
                            .cornerRadius(100)
                            .padding(.horizontal)
                }
            }
            .padding(.bottom)
        
    }
}

struct UserCard: View {
    let user: User
    
    var body: some View {
        VStack {
            Text(user.userName ?? "")
                .font(.headline)
            
            Text(formatDate(user.userBirthday ?? Date()))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
