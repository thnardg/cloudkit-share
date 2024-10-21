//
//  ThinkingOfYouViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 07/10/24.
//

import Foundation
import SwiftUI
import CoreData

class ThinkingOfYouViewModel: ObservableObject {
    private let stack = CoreDataStack.shared

    func addOrUpdateThought(for user: User, hasThoughtOnPartner: Bool) {
        stack.addOrUpdateThought(for: user, hasThoughtOnPartner: hasThoughtOnPartner)
    }
}
