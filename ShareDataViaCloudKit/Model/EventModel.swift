//
//  File.swift
//  MacroApp
//
//  Created by luis fontinelles on 09/10/24.
//

import Foundation

// model de datas especiais
//struct Event: Identifiable {
//    var id = UUID().uuidString
//    var title: String
//    var time: Date = Date()
//}

struct Event: Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var eventDate: Date
    var eventCategory: EventCategory
}

// Total de importantdate
struct EventMetaData: Identifiable {
    var id = UUID().uuidString
    var events: [Event]
}

#warning("função para mockar eventos")
func getSampleDate(offSet: Int) -> Date {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offSet, to: Date())
    return date ?? Date()
}
