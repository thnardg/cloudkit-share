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
        VStack {
            ThinkingOfYouView(room: room)
            CoupleMoodtrackerView(room: room)
            
            Button("Update your mood") {
                isMoodtrackerSheetPresented.toggle()
            }
            
            Text("Welcome to the Home View!")
            
            Text("\(viewModel.text)")
            Text("\(viewModel.CountableRange)")
            
            Button("Aumente mais 1 no countable range") {
                viewModel.increment()
            }
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
