//
//  File.swift
//  MacroApp
//
//  Created by luis fontinelles on 09/10/24.
//

import Foundation

struct DateValue: Hashable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
