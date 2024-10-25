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
        VStack(alignment: .leading) {
            Text("Thinking Of You").bold()
            BaseContainer(size: .small) {
                ThinkingOfYouView(room: room)
            }
        }
    }
}
