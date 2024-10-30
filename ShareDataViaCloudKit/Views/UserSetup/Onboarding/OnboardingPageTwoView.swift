//
//  OnboardingPageTwoView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 29/10/24.
//

import SwiftUI

struct OnboardingPageTwoView: View {
    var body: some View {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    
                    Text("Mais Amor & Diversão")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Text("Expresse seus sentimentos de um jeito divertido com stickers exclusivos. Transforme cada mensagem em um gesto de carinho.")
                        .padding()
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 120)
                }
                Spacer()
            }
            .background(
                    Image("Onboarding1")
                        .resizable()
                        .scaledToFill()
            )
    }
}

 #Preview {
     OnboardingPageTwoView()
 }
