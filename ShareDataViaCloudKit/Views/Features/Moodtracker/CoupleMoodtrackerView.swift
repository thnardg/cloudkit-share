//
//  CoupleMoodtrackerView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 24/10/24.
//

import SwiftUI

// Componente de moodtracker na home
struct CoupleMoodtrackerView: View {
    let room: Room

    var body: some View {
        HomeContainer(title: "Moodtracker", size: .medium) {
            HStack {
                IndividualMoodtrackerView(room: room, isPartner: false)
                Divider().padding()
                IndividualMoodtrackerView(room: room, isPartner: true)
            }
        }
    }
}