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
        
            VStack {
                if users.count >= 1 && users.count <= 2 {
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


import SwiftUI

struct NewUserView2: View {
    @State private var userName: String = ""
    @State private var userBirthday: Date = Calendar.current.date(from: DateComponents(year: 2001, month: 3, day: 28)) ?? Date()
    @State private var relationshipAnniversary: Date = Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 8)) ?? Date()
    @State private var isBirthdayPickerPresented: Bool = false
    @State private var isAnniversaryPickerPresented: Bool = false
    @Environment(\.sizeCategory) var sizeCategory
    
    var limitedSizeCategory: ContentSizeCategory {
        return sizeCategory > .extraExtraExtraLarge ? .extraExtraExtraLarge : sizeCategory
    }
    
    var body: some View {
        VStack {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.green.opacity(0.2))
                    .frame(maxWidth: 120, maxHeight: 120)
                    .aspectRatio(1, contentMode: .fit)
                
                Text("About You")
                    .font(.system(.title, design: .rounded))
                    .bold()
                    .padding(.top)
                
                Text("Personalize your experience!")
                    .font(.system(.subheadline, design: .rounded))
                    .padding(.bottom, 20)
            }
            
            
            VStack(spacing: 30) {
                InputField(title: "Your Name", text: $userName, icon: "person.fill")
                
                PickerSection(title: "Pronouns", options: ["She / her", "He / him", "They / them"], selection: .constant("She / her"))
                
                DatePickerSection(
                    title: "Your Birthday",
                    date: $userBirthday,
                    isPresented: $isBirthdayPickerPresented,
                    icon: "calendar"
                )
                
                DatePickerSection(
                    title: "Relationship Anniversary",
                    date: $relationshipAnniversary,
                    isPresented: $isAnniversaryPickerPresented,
                    icon: "heart.fill"
                )
            }
            
            OnboardingButton(title: "Done") {
                print("done")
            }.padding(.top, 40)
        }
        .padding()
        .environment(\.sizeCategory, limitedSizeCategory)
    }
}

// MARK: - InputField Component
struct InputField: View {
    let title: String
    @Binding var text: String
    let icon: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline, design: .rounded))
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray.opacity(0.4))
                
                TextField(title, text: $text)
                    .focused($isFocused)
                    .padding(.vertical, 10)
                    .font(.system(.callout, design: .rounded))
            }
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? Color.purple : Color.gray.opacity(0.4), lineWidth: 2)
            )
        }
    }
}

// MARK: - PickerSection Component
struct PickerSection: View {
    let title: String
    let options: [String]
    @Binding var selection: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline, design: .rounded))
            HStack {
                Text(title).font(.system(.callout, design: .rounded))
                Spacer()
                Picker(title, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                            .font(.system(.callout, design: .rounded))
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(5)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

// MARK: - DatePickerSection Component
struct DatePickerSection: View {
    let title: String
    @Binding var date: Date
    @Binding var isPresented: Bool
    let icon: String
    @State private var isButtonSelected: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline, design: .rounded))
            
            Button(action: {
                isPresented.toggle()
                isButtonSelected.toggle()
            }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.gray.opacity(0.4))
                    Text(date, style: .date)
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                        .font(.system(.callout, design: .rounded))
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isButtonSelected ? Color.purple : .gray.opacity(0.4), lineWidth: 2)
                )
            }
            .sheet(isPresented: $isPresented) {
                VStack {
                    DatePicker("Select \(title)", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    .padding()
                }
                .presentationDetents([.medium, .fraction(0.3)])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    NewUserView2()
}
