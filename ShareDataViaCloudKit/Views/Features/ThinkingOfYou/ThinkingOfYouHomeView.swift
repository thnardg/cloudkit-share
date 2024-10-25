//
//  ThinkingOfYouHomeView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 25/10/24.
//

import SwiftUI

struct ThinkingOfYouHomeView: View {
    let room: Room

    var body: some View {
        HomeContainer(title: "Thinking of You", size: .small) {
            ThinkingOfYouView(room: room)
        }
    }
}
