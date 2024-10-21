//
//  SwiftUIView.swift
//  MacroApp
//
//  Created by luis fontinelles on 02/10/24.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject var viewModel = CalendarViewModel()
    @State private var settingsDetent = PresentationDetent.medium
    
    @State var isAddViewPresented = false

    
    var body: some View {
        NavigationView {
                VStack(spacing: 20) {
                    // Custom date picker
                    CustomDatePicker(viewModel: viewModel)
                }
                .sheet(isPresented: $viewModel.isDetailEventsViewPresented) {
                    DetailEventsView(viewModel: viewModel)
                        .presentationDetents(
                                            [.medium, .large],
                                            selection: $settingsDetent
                                         )
                }
                .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddViewPresented.toggle()
                    }) {
                        Image(systemName: "plus.app")
                    }
                    .sheet(isPresented: $isAddViewPresented) {
                        AddEventView(viewModel: viewModel, isAddViewPresented: $isAddViewPresented)
                    }
                }
            }
            .navigationTitle(viewModel.extraDate()[1])
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

struct DetailEventsView: View {
    
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Events")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 20)
            
            // Filtra os eventos para o dia atual
            let todayEvents = viewModel.events.filter { event in
                viewModel.isSameDay(date1: event.eventDate, date2: viewModel.currentDate)
            }
            
            if !todayEvents.isEmpty {
                // Exibe apenas os eventos filtrados
                ForEach(todayEvents) { event in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(event.title)
                                .font(.title2.bold())
                            
                            Spacer()
                            
                            Text(event.eventCategory.rawValue)
                                .font(.callout.bold())
                        }
                        Text(event.description)
                            .font(.callout)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        Color(.red)
                            .opacity(0.3)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    )
                }
            } else {
                Text("No events found")
            }
        }
        .padding()
        .padding(.top, 20)
    }
}


#Preview {
    CalendarView()
//    AddEventView(viewModel: CalendarViewModel(), isAddViewPresented: .constant(false))
}
