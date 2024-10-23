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

    let moodImages = ["cloud.sun.circle.fill", "cloud.drizzle.circle.fill", "cloud.snow.circle.fill", "cloud.moon.bolt.circle.fill", "cloud.circle.fill", "cloud.sleet.circle.fill"]
    
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 10, maximum: 100)),
        GridItem(.flexible(minimum: 10, maximum: 100)),
        GridItem(.flexible(minimum: 10, maximum: 100))
    ]
    
    var body: some View {
        VStack {
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
            }
            
            LazyVGrid(columns: self.columns) {
                ForEach(Array(viewmodel.moods.enumerated()), id: \.element) { index, mood in
                    Button(action: {
                        viewmodel.updateButtonStates(selectedIndex: index, userUUID: userUUID)
                    }) {
                        VStack {
                            Image(systemName: moodImages[index])
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.blue.opacity(viewmodel.buttonStates[index] == .selected || viewmodel.buttonStates[index] == .none ? 0.5 : 0.2))
                                .scaleEffect(viewmodel.buttonStates[index] == .selected ? 1.1 : 1.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0), value: viewmodel.buttonStates[index])
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
        }
        .padding()
        .onAppear {
            viewmodel.fetchUsers(for: room, with: userUUID)
        }
    }
}


struct CoupleMoodtrackerView: View {
    var body: some View {
        VStack {
            Text("Seu nome").textCase(.uppercase)
            Image(systemName: "icloud.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            Text("Mood").bold()
        }
    }
}
