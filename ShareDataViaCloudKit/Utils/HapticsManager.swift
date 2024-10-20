//
//  HapticManager.swift
//  MacroApp
//
//  Created by Lucas Pontes on 30/09/24.
//

import Foundation
import UIKit

@MainActor
class HapticManager {
    static let shared = HapticManager()

    private init() {}

    // MARK: - Public Methods

    // Feedback relacionado a notificações
    func playStandardFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    // feedback relacionado a impactos, como objetos colidindo
    func playImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    // feedback ao usuário quando ele muda a seleção de um elemento na interface do usuário
    func playSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }


    // MARK: - Private Methods

    private func playHapticWithCustomParameters(intensity: Float, sharpness: Float) {
        
    }
}
