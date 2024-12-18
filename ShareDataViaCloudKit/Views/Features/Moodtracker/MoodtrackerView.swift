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
    
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 10, maximum: 100)),
        GridItem(.flexible(minimum: 10, maximum: 100)),
        GridItem(.flexible(minimum: 10, maximum: 100))
    ]
    
    var body: some View {
        VStack {
            Text("How do you feel today?").font(.title2.bold()).padding()
            Spacer()
            LazyVGrid(columns: self.columns) {
                ForEach(Array(Mood.allCases.enumerated()), id: \.element) { index, mood in
                    Button(action: {
                        HapticsManager.medium.generate()
                        selectedMoodIndex = selectedMoodIndex == index ? nil : index
                    }) {
                        VStack {
                            Image(systemName: mood.imageName)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.blue.opacity(selectedMoodIndex == index ? 0.5 : 0.2))
                                .scaleEffect(selectedMoodIndex == index ? 1.1 : 1.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0), value: selectedMoodIndex)
                            Text(mood.rawValue)
                                .foregroundStyle(Color.blue.opacity(selectedMoodIndex == index ? 0.5 : 0.2))
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
                    if let selectedIndex = selectedMoodIndex,
                       let currentUser = viewmodel.users.first(where: { $0.id == userUUID }) {
                        let selectedMood = Mood.allCases[selectedIndex]
                        viewmodel.addOrUpdateMood(for: currentUser, selectedMood: selectedMood)
                        HapticsManager.medium.generate()
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
