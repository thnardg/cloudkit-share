//
//  LittleNoteHomeView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 26/10/24.
//

import SwiftUI

struct LittleNoteHomeView: View {

    var body: some View {
        VStack(alignment: .leading) {
            Text("Little note").bold()
            BaseContainer(size: .large) {
                LittleNoteView()
            }
        }
    }
}

#Preview {
    LittleNoteHomeView()
}
