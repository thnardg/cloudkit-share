//
//  OnboardingPageThreeView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 29/10/24.
//

import SwiftUI

struct OnboardingPageThreeView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("Descubra uma nova forma de fortalecer seu relacionamento")
                    .font(.largeTitle).bold()
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Text("Conecte-se com o seu parceiro e tenha acesso a widgets incríveis para manter o amor sempre presente!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    // Continue button action here
                }) {
                    Text("Continuar")
                        .font(.headline)
                        .padding()
                        .padding(.horizontal, 25)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .padding(.bottom, 120)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            Spacer()
        }
            .background(Image("Onboarding2")
                .resizable()
                .scaledToFill()
            )
    }
}

#Preview {
    OnboardingPageThreeView()
}
