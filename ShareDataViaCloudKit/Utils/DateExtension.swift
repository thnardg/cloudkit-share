//
//  DateExtension.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 24/10/24.
//

import Foundation

extension Date {
    func formattedForDisplay() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
        
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            let timeString = timeFormatter.string(from: self)
            return "Today • \(timeString)"
        } else {
            return timeFormatter.string(from: self)
        }
    }
}
