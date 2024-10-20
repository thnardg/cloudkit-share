//
//  MoodtrackerView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 17/10/24.
//

import SwiftUI
import CoreData

struct MoodtrackerView: View {
    let room: Room

    @AppStorage("userUUID") private var userUUID: String = "" //uuid local
    
    @StateObject private var viewmodel = MoodtrackerViewModel()
    @State private var selectedMoodIndex: Int? = nil
    @State private var buttonSelectionCount: Int = 0
    @State private var buttonIsSelected: Bool = false
    
    let moods = ["Happy", "Sad", "Excited", "Angry", "Calm", "Anxious", "Grateful", "Bored", "Frustrated", "Inspired", "Relaxed", "Tired"]
    
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 10, maximum: 100)),
        GridItem(.flexible(minimum: 10, maximum: 100)),
        GridItem(.flexible(minimum: 10, maximum: 100))
    ]
    
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
            VStack {
                if let currentUser = users.first(where: { $0.id == userUUID }) {
                    // Display your latest mood
                    if let myMood = viewmodel.latestUserMood {
                        Text("Your latest mood: \(myMood.mood ?? "Unknown")")
                            .font(.headline)
                    } else {
                        Text("No mood recorded for you yet.")
                            .font(.subheadline)
                    }

                    // Display latest partner's mood
                    if let partnerMood = viewmodel.latestPartnerMood {
                        let partnerName = partnerMood.user?.userName ?? "Parceiro"
                        Text("\(partnerName)'s latest mood: \(partnerMood.mood ?? "Unknown")")
                            .font(.headline)
                    } else {
                        Text("No mood recorded for partner yet.")
                            .font(.subheadline)
                    }
                }
            }

                
            LazyVGrid(columns: self.columns) {
                ForEach(Array(moods.enumerated()), id: \.element) { index, mood in
                    Button(action: {
                        buttonIsSelected = true
                        buttonSelectionCount = buttonIsSelected ? 1 : 0
                        if selectedMoodIndex == index {
                            selectedMoodIndex = nil
                            print("Mood deselected")
                        } else {
                            selectedMoodIndex = index
                            print("Selected mood: \(mood)")
                            if let currentUser = users.first(where: { $0.id == userUUID }) {
                                viewmodel.addOrUpdateMood(for: currentUser, selectedMood: mood) 
                            }
                        }
                    }) {
                        VStack {
                            Image(systemName: "icloud.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.blue.opacity(selectedMoodIndex == index || buttonSelectionCount < 1 ? 0.5 : 0.2))
                                .scaleEffect(selectedMoodIndex == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0), value: selectedMoodIndex)
                            Text(mood)
                                .foregroundColor(Color.blue)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }.padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .onAppear() {
            if let currentUser = users.first(where: { $0.id == userUUID }) {
                viewmodel.fetchLatestUserMood(for: currentUser)
                viewmodel.fetchLatestPartnerMood(for: currentUser, in: room)
            }
        }
    }
}


class MoodtrackerViewModel: ObservableObject {
    private let stack = CoreDataStack.shared
    @Published var latestPartnerMood: Moodtracker?
    @Published var latestUserMood: Moodtracker?

    // Fetch the most recent mood of the partner in the same room
    func fetchLatestPartnerMood(for user: User, in room: Room) {
        let fetchRequest: NSFetchRequest<Moodtracker> = Moodtracker.fetchRequest()
        // Filter to exclude the current user, ensure they are in the same room, and get the partner's mood
        fetchRequest.predicate = NSPredicate(format: "user != %@ AND user.room == %@", user, room)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "moodDate", ascending: false)]
        fetchRequest.fetchLimit = 1

        if let fetchedMood = try? stack.context.fetch(fetchRequest).first {
            DispatchQueue.main.async {
                self.latestPartnerMood = fetchedMood
            }
        }
    }

    // Fetch the most recent mood for the current user
    func fetchLatestUserMood(for user: User) {
        let fetchRequest: NSFetchRequest<Moodtracker> = Moodtracker.fetchRequest()
        // Filter to only include moods for the current user
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "moodDate", ascending: false)]
        fetchRequest.fetchLimit = 1

        if let fetchedMood = try? stack.context.fetch(fetchRequest).first {
            DispatchQueue.main.async {
                self.latestUserMood = fetchedMood
            }
        }
    }

    // Add or update a new mood for the current user
    func addOrUpdateMood(for user: User, selectedMood: String) {
        stack.addOrUpdateMood(for: user, selectedMood: selectedMood)
        fetchLatestUserMood(for: user)  // Fetch the latest mood for the current user
        fetchLatestPartnerMood(for: user, in: user.room!)  // Fetch the latest partner mood in the same room
    }
}
