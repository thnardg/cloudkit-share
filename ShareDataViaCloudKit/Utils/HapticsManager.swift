//
//  CustomHapticFeedback.swift
//  SwiftShareData
//
//  Created by Thayná Rodrigues on 04/04/24.
//

import SwiftUI

enum HapticsManager {
    case success
    case warning
    case error
    case light
    case medium
    case heavy
    
    func generate() {
        let generator: UIImpactFeedbackGenerator
        switch self {
        case .success:
            generator = UIImpactFeedbackGenerator(style: .soft)
        case .warning:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .error:
            generator = UIImpactFeedbackGenerator(style: .medium)
        case .light:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .medium:
            generator = UIImpactFeedbackGenerator(style: .medium)
        case .heavy:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        }
        generator.impactOccurred()
    }
}
