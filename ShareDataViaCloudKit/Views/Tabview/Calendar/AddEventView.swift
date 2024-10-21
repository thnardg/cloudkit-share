//
//  AddEventView.swift
//  MacroApp
//
//  Created by luis fontinelles on 10/10/24.
//

import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    @State var eventTitle: String = ""
    @State var eventDescription: String = "" // Adicionado para descrição do evento
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    @State private var selectedMonth: String
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    @Binding var isAddViewPresented: Bool
    
    // Nova propriedade para armazenar a categoria do evento
    @State private var selectedCategory: EventCategory = .work // Valor padrão

    init(viewModel: CalendarViewModel, isAddViewPresented: Binding<Bool>) {
        self.viewModel = viewModel
        _selectedMonth = State(initialValue: viewModel.getMonths().first ?? "")
        self._isAddViewPresented = isAddViewPresented
    }

    var body: some View {
        VStack {
            Text("Adicionar Evento")
                .font(.title)
                .padding()

            TextField("Título do Evento", text: $eventTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .accessibility(label: Text("Título do Evento"))
            
            // Novo TextField para Descrição do Evento
            TextField("Descrição do Evento", text: $eventDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .accessibility(label: Text("Descrição do Evento"))

            // Picker para selecionar o dia
            Picker("Selecione um Dia", selection: $selectedDay) {
                ForEach(daysInMonth(), id: \.self) { day in
                    Text("\(day)").tag(day)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            // Picker para selecionar o mês
            Picker("Selecione um Mês", selection: $selectedMonth) {
                ForEach(viewModel.getMonths(), id: \.self) { month in
                    Text(month).tag(month)
                        .onChange(of: selectedMonth) { _, _ in
                            selectedDay = 1 // Resetar o dia ao mudar o mês
                        }
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            // Picker para selecionar o ano
            Picker("Selecione um Ano", selection: $selectedYear) {
                ForEach(viewModel.getYears(), id: \.self) { year in
                    Text("\(year)").tag(year)
                        .onChange(of: selectedYear) { _, _ in
                            selectedDay = 1 // Resetar o dia ao mudar o ano
                        }
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            // Picker para selecionar a categoria do evento
            Picker("Selecione uma Categoria", selection: $selectedCategory) {
                ForEach(EventCategory.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle()) // Use o estilo de menu para exibir as opções
            .padding()

            Spacer()
            Button(action: {
                viewModel.addEvent(title: eventTitle, description: eventDescription, day: String(selectedDay), month: selectedMonth, year: selectedYear, category: selectedCategory)
                isAddViewPresented = false
                
            }) {
                Text("Adicionar Evento")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
    
    private func daysInMonth() -> [Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let selectedDateString = "\(selectedMonth) \(selectedYear)"
        guard let selectedDate = dateFormatter.date(from: selectedDateString) else {
            return []
        }
        
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: selectedDate)
        return Array(range!.compactMap { $0 })
    }
}

#Preview {
    AddEventView(viewModel: CalendarViewModel(), isAddViewPresented: .constant(false))
}

