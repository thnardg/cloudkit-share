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
                VStack(alignment: .leading, spacing: 4) {
                    Text("Seu nome") // Title text
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "person.fill") // Icon inside the TextField
                            .foregroundColor(.gray)
                        
                        TextField("Seu nome", text: $userName)
                            .textFieldStyle(PlainTextFieldStyle()) // Plain style to avoid rounded borders
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)
                }

                
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
                        print("----------------------------------------------------------------------------")
                        print("User Details:")
                        print("UUID: \(userUUID)")
                        print("Name: \(userName)")
                        print("Birthday: \(userBirthday)")
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
                if users.count <= 2 || users.count == 1 {
                        NavigationLink(destination: MainTabView(room: room)) {
                            Text("Done")
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
