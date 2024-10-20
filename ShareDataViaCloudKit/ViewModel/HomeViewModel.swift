//
//  HomeViewModel.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 20/10/24.
//

import SwiftUI

public class HomeViewModel: ObservableObject {

    @Published var text: String = "Hello, World!"
    @Published var CountableRange: Int = 0
 
    func increment() {
        CountableRange += 1
    }
}
