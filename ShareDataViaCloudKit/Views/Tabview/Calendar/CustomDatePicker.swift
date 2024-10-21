//
//  CustomDatePicker.swift
//  Calendar
//
//  Created by luis fontinelles on 09/10/24.
//

import SwiftUI

struct CustomDatePicker: View {
    
    @ObservedObject var viewModel: CalendarViewModel
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        VStack(spacing: 35) {
            
            
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.extraDate()[0])
                        .font(.title2).fontWeight(.semibold)
                }
                
                Spacer()
                
                Button {
                    viewModel.currentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    viewModel.currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding()
            
            // Dias da semana
            WeeksView()
            
            // Datas
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(viewModel.extractDate(), id: \.self) { date in
                    CardView(date: date)
                        .background(
                            Capsule()
                                .stroke(viewModel.isToday(date.date) ? .black : .clear, lineWidth: 2)
                                .fill(.red)
                                .padding(.horizontal, 8)
                                .opacity(viewModel.isSameDay(date1: date.date, date2: viewModel.currentDate) ? 1 : 0)
                            
                        )
                        .onTapGesture {
                            viewModel.currentDate = date.date
                            viewModel.showDetailEventView(for: date.date)
                        }
                }
            }
            
            Spacer()
            
        }
        .frame(maxHeight: .infinity)
        .onChange(of: viewModel.currentMonth) { _, newValue in
            viewModel.currentDate = viewModel.getCurrentMonth()
        }
    }
    
    //view da fileira que mostra os nomes dos dias semana
    @ViewBuilder
    func WeeksView() -> some View {
        HStack(spacing: 0) {
            if dynamicTypeSize < .accessibility1 {
                ForEach(viewModel.days, id: \.self) { day in
                    Text(day)
                        .font(.callout).fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            } else {
                // se for ax1 pra cima so mostre a primeira letra do dia da semana
                ForEach(viewModel.days, id: \.self) { day in
                    Text(String(day.prefix(1)))
                        .font(.callout).fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    
    //construção do calendário
    @ViewBuilder
    func CardView(date: DateValue) -> some View {
        VStack {
            if date.day != -1 {
                if let event = viewModel.eventsForCurrentMonth().first(where: { event in
                    return viewModel.isSameDay(date1: event.eventDate, date2: date.date)
                }) {
                    Text("\(date.day)")
                        .font(dynamicTypeSize > .accessibility1 ? .system(size: 30) : .title3)
                        .bold()
                        .foregroundStyle(viewModel.isSameDay(date1: date.date, date2: viewModel.currentDate) ? .white : viewModel.isToday(date.date) ? .red : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .foregroundStyle(viewModel.isSameDay(date1: event.eventDate, date2: viewModel.currentDate) ? .white : .red)
                        .frame(width: 8, height: 8)
                    
                    
                } else {
                    Text("\(date.day)")
                        .font(dynamicTypeSize > .accessibility1 ? .system(size: 30) : .title3)
                        .bold()
                        .foregroundStyle(viewModel.isSameDay(date1: date.date, date2: viewModel.currentDate) ? .white : viewModel.isToday(date.date) ? .red : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height:60, alignment: .top)
    }
}
