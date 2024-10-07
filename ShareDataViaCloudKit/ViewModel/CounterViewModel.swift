//
//  CounterViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import Foundation
import SwiftUI
import CloudKit

class CounterViewModel: ObservableObject {
    private let stack = CoreDataStack.shared

    func incrementCounter(_ counter: Counter, for room: Room) {
        if stack.isOwner(object: room) {
            counter.userOneCount += 1
        } else {
            counter.userTwoCount += 1
        }
        self.stack.incrementCounter(counter)
    }


        func createCounter(for room: Room) {
            stack.addCounter(to: room)
        }
}
