//
//  LittleNoteView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 26/10/24.
//

import SwiftUI

struct LittleNoteView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Little note from [Partner]")
                .font(.system(size: 11))
                .textCase(.uppercase)
                .foregroundStyle(.gray)
            
            // NOTE
            Spacer()
            
            HStack {
                Text("Today - 12:00 PM").font(.caption2).italic().foregroundStyle(.gray)
                Spacer()
            }
            
        }.padding(20)
    }
}

#Preview {
    LittleNoteView()
}
