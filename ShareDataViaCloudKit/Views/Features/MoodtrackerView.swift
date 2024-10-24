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
    
    @AppStorage("userUUID") private var userUUID: String = ""
    @StateObject private var viewmodel = MoodtrackerViewModel()
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedMoodIndex: Int? = nil
    
    let moodImages = ["cloud.sun.circle.fill", "cloud.drizzle.circle.fill", "cloud.snow.circle.fill", "cloud.moon.bolt.circle.fill", "cloud.circle.fill", "cloud.sleet.circle.fill"]
    
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 10, maximum: 100)),
        GridItem(.flexible(minimum: 10, maximum: 100)),
        GridItem(.flexible(minimum: 10, maximum: 100))
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: self.columns) {
                ForEach(Array(viewmodel.moods.enumerated()), id: \.element) { index, mood in
                    Button(action: {
                        selectedMoodIndex = selectedMoodIndex == index ? nil : index // Toggle selection
                    }) {
                        VStack {
                            Image(systemName: moodImages[index])
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.blue.opacity(selectedMoodIndex == index ? 0.5 : 0.2))
                                .scaleEffect(selectedMoodIndex == index ? 1.1 : 1.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0), value: selectedMoodIndex)
                            Text(mood)
                                .foregroundColor(Color.blue)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if let selectedIndex = selectedMoodIndex, let currentUser = viewmodel.users.first(where: { $0.id == userUUID }) {
                        let selectedMood = viewmodel.moods[selectedIndex]
                        viewmodel.addOrUpdateMood(for: currentUser, selectedMood: selectedMood)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .padding()
                        .foregroundStyle(selectedMoodIndex != nil ? Color.pink : Color.gray)
                }
                .disabled(selectedMoodIndex == nil)
            }
        }
        .padding()
        .onAppear {
            viewmodel.fetchUsers(for: room, with: userUUID)
        }
    }
}


// HOME
struct CoupleMoodtrackerView: View {
    let room: Room
    @AppStorage("userUUID") private var userUUID: String = ""

    @StateObject private var viewmodel = MoodtrackerViewModel()

    var body: some View {
        VStack {
            if let myMood = viewmodel.todaysUserMood {
                Text("Your latest mood: \(myMood.mood ?? "Unknown")")
                    .font(.headline)
            } else {
                Text("No mood recorded for you yet.")
                    .font(.subheadline)
            }
            
            if let partnerMood = viewmodel.todaysPartnerMood {
                let partnerName = partnerMood.user?.userName ?? "Parceiro"
                Text("\(partnerName)'s latest mood: \(partnerMood.mood ?? "")")
                    .font(.headline)
            } else {
                Text("No mood recorded for partner today.")
                    .font(.subheadline)
            }
        }.onAppear {
            viewmodel.fetchUsers(for: room, with: userUUID)
        }
    }
}
