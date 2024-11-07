//
//  Components+Buttons.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 25/10/24.
//

import SwiftUI

//MARK: -- Botões dos widgets da home (com ícone e sem ícone)
struct HomeWidgetButton: View {
    var title: String
    var icon: String?
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
            HapticsManager.success.generate()
        }) {
            HStack {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
        }
        .font(.system(size: 14))
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .bold()
        .background(Color.black)
        .cornerRadius(100)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}

#Preview {
    HomeWidgetButton(title: "Think Of Them", action: {})
}


struct OnboardingButton: View {
    var title: String
    var action: () -> Void
    var backgroundColor: Color = .purple
    var foregroundColor: Color = .white

    var body: some View {
        Button(action: {
            withAnimation {
                action()
                HapticsManager.success.generate()
            }
        }) {
            Text(title)
                .font(.system(.body, design: .rounded)).bold()
                .padding(.horizontal, 40)
                .padding()
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .cornerRadius(100)
        }
    }
}
