//
//  SwiftUIView.swift
//  MacroApp
//
//  Created by luis fontinelles on 09/10/24.
//

import SwiftUI

enum EventCategory: String, CaseIterable {
    case work = "work"
    case date = "date"
    //essa foi a forma que arranjei de traduzir rolê
    case takeOff = "take off"
    case commemorativeDates = "commemorative dates"
    case socializing = "socializing"
    // aniversário de namoro e aniversário de cada um
    case anniversary = "anniversary"
    case travel = "travel"
    //volta no parque, academia...
    case health = "health"
    //reuniao familiar, culto
    case appointments = "appointments"
}


class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var currentMonth: Int = 0
    
    @Published var isDetailEventsViewPresented: Bool = false

    let today = Date()
    
#warning("alterar events pelo atributo events do coredata")
    // Lista de eventos
    // esses dados estao mockados, mas também é a variável que recebe os eventos adicionados manualmente
    lazy var events: [Event] = [
            Event(title: "Aniversário de João", description: "Festa de aniversário em casa", eventDate: getSampleDate(offSet: -20), eventCategory: .anniversary),
            Event(title: "Consulta médica", description: "Consulta de rotina com o Dr. Silva", eventDate: getSampleDate(offSet: 1), eventCategory: .health),
            Event(title: "Entrega do projeto", description: "Projeto final do curso de programação", eventDate: getSampleDate(offSet: 3), eventCategory: .work),
            Event(title: "Churrasco com amigos", description: "Churrasco no sítio do Paulo", eventDate: getSampleDate(offSet: 4), eventCategory: .socializing),
            Event(title: "Reunião com chefe", description: "Reunião de planejamento para o próximo trimestre", eventDate: getSampleDate(offSet: 5), eventCategory: .work),
            Event(title: "Casamento de Maria", description: "Cerimônia na igreja", eventDate: getSampleDate(offSet: -3), eventCategory: .anniversary),
            Event(title: "Check-up no dentista", description: "Exame dentário", eventDate: getSampleDate(offSet: -2), eventCategory: .health),
            Event(title: "Férias começam", description: "Início das férias de verão", eventDate: getSampleDate(offSet: -1), eventCategory: .travel),
            Event(title: "Almoço em família", description: "Almoço de domingo com a família", eventDate: getSampleDate(offSet: 0), eventCategory: .socializing),
            Event(title: "Final da Copa", description: "Jogo final da Copa do Mundo", eventDate: getSampleDate(offSet: 2), eventCategory: .socializing)
    ]


    // Dias
    let days: [String] = [
        String(localized: "Sun", table: "Localizable", bundle: .main, locale: Locale(identifier: "en"), comment: ""),
        String(localized: "Mon", table: "Localizable", bundle: .main, locale: Locale(identifier: "en"), comment: ""),
        String(localized: "Tue", table: "Localizable", bundle: .main, locale: Locale(identifier: "en"), comment: ""),
        String(localized: "Wed", table: "Localizable", bundle: .main, locale: Locale(identifier: "en"), comment: ""),
        String(localized: "Thu", table: "Localizable", bundle: .main, locale: Locale(identifier: "en"), comment: ""),
        String(localized: "Fri", table: "Localizable", bundle: .main, locale: Locale(identifier: "en"), comment: ""),
        String(localized: "Sat", table: "Localizable", bundle: .main, locale: Locale(identifier: "en"), comment: "")
    ]

    
    func getMonths() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let calendar = Calendar.current
        
        return calendar.monthSymbols
    }

    // Função para obter os anos desde 100 anos atrás até 100 anos à frente
    func getYears() -> [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear - 100)...(currentYear + 100))
    }
    
    // Atualiza a UI após adicionar um evento
    func refreshEvents() {
        objectWillChange.send()
    }

    //adiciona um evento a eventos
    func addEvent(title: String, description: String, day: String, month: String, year: Int, category: EventCategory) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        if let date = dateFormatter.date(from: "\(day) \(month) \(year)") {
            let newEvent = Event(title: title, description: description, eventDate: date, eventCategory: category)
            events.append(newEvent)
            print("Evento adicionado: \(newEvent.title) na data \(dateFormatter.string(from: date))")
            
            refreshEvents()

        } else {
            print("Erro ao criar a data com os dados fornecidos.")
        }
    }
    
    // Verificar se as datas são iguais
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    //verificar se possui evento para alterar a sheet
    func showDetailEventView(for date: Date) {
        if let _ = events.first(where: { event in
            return isSameDay(date1: event.eventDate, date2: date)
        }) {
            isDetailEventsViewPresented.toggle() // Alterna o estado se houver um evento
        }
    }
    
    //retorna pra variável today, porque a currentdata pode mudar
    func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDate(today, inSameDayAs: date)
    }

    
    // Extraindo as datas formatadas (Ano e Mês)
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    // Obter o mês atual ajustado com base em currentMonth
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    // Filtra eventos para o mês atual
    func eventsForCurrentMonth() -> [Event] {
        let calendar = Calendar.current
        
        return events.filter { event in
            // Compara apenas mês e ano
            return calendar.isDate(event.eventDate, equalTo: currentDate, toGranularity: .month)
        }
    }
    
    // Extraindo as datas do mês
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = self.getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekDay - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}


extension Date {
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        //getting start date///
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of:.day, in:.month, for: startDate)!
        
        
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
