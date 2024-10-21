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
    @AppStorage("userUUID") private var userUUID: String = "" // uuid local
    
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
    
    var body: some View {
        VStack {
            VStack {
                    if let myMood = viewmodel.latestUserMood {
                        Text("Your latest mood: \(myMood.mood ?? "Unknown")")
                            .font(.headline)
                    } else {
                        Text("No mood recorded for you yet.")
                            .font(.subheadline)
                    }

                    if let partnerMood = viewmodel.latestPartnerMood {
                        let partnerName = partnerMood.user?.userName ?? "Parceiro"
                        Text("\(partnerName)'s latest mood: \(partnerMood.mood ?? "Unknown")")
                            .font(.headline)
                    } else {
                        Text("No mood recorded for partner yet.")
                            .font(.subheadline)
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
                            if let currentUser = viewmodel.users.first(where: { $0.id == userUUID }) {
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
        .onAppear {
            viewmodel.fetchUsers(for: room, with: userUUID)
        }
    }
}
