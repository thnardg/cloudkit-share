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
            ScrollView {
                HStack {
                    ThinkingOfYouHomeView(room: room)
                    // TODO: -- Adicionar o countdown de dias juntos aqui
                    Spacer()
                }
                Spacer()
                
                // TODO: -- Adicionar a pergunta do dia aqui
                // TODO: -- Adicionar o recado aqui

                Button {
                    isMoodtrackerSheetPresented.toggle()
                    HapticsManager.medium.generate()
                } label: {
                    CoupleMoodtrackerView(room: room)
                }.buttonStyle(PlainButtonStyle())
                
                // TODO: -- Adicionar timezones aqui
                // TODO: -- Adicionar outros countdowns aqui

                Spacer()
            }.padding()
        }
        .sheet(isPresented: $isMoodtrackerSheetPresented) {
            NavigationStack {
                MoodtrackerView(room: room)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                isMoodtrackerSheetPresented = false
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
            }
        }.presentationDragIndicator(.visible)
    }
}
