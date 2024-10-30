//
//  OnboardingView.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 28/10/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if currentPage == 0 {
                    OnboardingPageOneView()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                if currentPage == 1 {
                    OnboardingPageTwoView()
                        .transition(
                            .asymmetric(
                                insertion: .opacity.combined(with: .offset(y: -50)),
                                removal: .opacity)
                            
                        )
                }
                
                if currentPage == 2 {
                    OnboardingPageThreeView()
                        .transition(.opacity)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            currentPage -= 1
                        }) {
                            Image(systemName: "chevron.backward")
                                .padding(20)
                                .background(currentPage <= 0 ? Color.clear : Color.blue.opacity(0.2))
                                .foregroundStyle(currentPage <= 0 ? Color.clear : Color.blue)
                                .clipShape(Circle())
                        }.disabled(currentPage <= 0 ? true : false)
                        
                        Spacer()
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(index == currentPage ? .gray : .white)
                            }
                        }
                        Spacer()
                        Button(action: {
                            currentPage += 1
                        }) {
                            Image(systemName: "chevron.forward")
                                .padding(20)
                                .background(currentPage >= 2 ? Color.clear : Color.blue.opacity(0.2))
                                .foregroundStyle(currentPage >= 2 ? Color.clear : Color.blue)
                                .clipShape(Circle())
                        }.disabled(currentPage >= 2 ? true : false)
                    }
                }.padding()
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -50 {
                            if currentPage < 2 {
                                currentPage += 1
                            }
                        } else if value.translation.width > 50 {
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        }
                    }
            )
            .animation(.easeInOut(duration: 0.5), value: currentPage)
            Spacer()
        }.background(Color.grayOnboarding)
    }
}

#Preview {
    OnboardingView()
}
