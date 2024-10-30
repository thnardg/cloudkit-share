//
//  OnboardingPageOneView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 29/10/24.
//

import SwiftUI

struct OnboardingPageOneView: View {
    var body: some View {
        VStack {
            Text("Pequenos Gestos, Grandes Momentos")
                .font(.largeTitle).bold()
                .multilineTextAlignment(.center)
            
            Image(.onboardingnote)
                .resizable().scaledToFit().frame(height: 200)
                .padding(30)
            
            Text("Cada gesto conta! Por isso, cultive momentos especiais todos os dias com pequenas demonstrações de carinho que fazem toda a diferença no relacionamento.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    OnboardingPageOneView()
}
