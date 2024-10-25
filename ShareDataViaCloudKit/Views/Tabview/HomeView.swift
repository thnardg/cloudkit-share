//
//  HomeView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 20/10/24.
//

import SwiftUI

struct HomeView: View {
    var room: Room
    @ObservedObject var viewModel = HomeViewModel()
    @State var info: Bool = false
    @State private var isMoodtrackerSheetPresented = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea(.all)
            VStack {
                HStack {
                    ThinkingOfYouView(room: room)
                    
                    Spacer()
                }
                Spacer()
                CoupleMoodtrackerView(room: room)
                Button("Update your mood") {
                    isMoodtrackerSheetPresented.toggle()
                }

                Spacer()
            }.padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) { Image(systemName: "gearshape") }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {}) { Image(systemName: "person") }
            }
            
        }
        .sheet(isPresented: $isMoodtrackerSheetPresented) {
            MoodtrackerView(room: room)
        }
    }
}
