//
//  Components+Containers.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 24/10/24.
//

import SwiftUI

// MARK: -- Base pra criação dos blocos da home
struct HomeContainer<Content: View>: View {
    var title: String
    var size: ContainerSize
    var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).bold()
            
            VStack {
                content()
            }
            .background(Color.white)
            .cornerRadius(22)
            .frame(width: size.dimensions.width, height: size.dimensions.height)
        }
    }
}

// MARK: -- Base pra criação de blocos (sem título)
struct BasicContainer<Content: View>: View {
    var title: String
    var size: ContainerSize
    var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).bold()
            
            VStack {
                content()
            }
            .background(Color.white)
            .cornerRadius(22)
            .frame(width: size.dimensions.width, height: size.dimensions.height)
        }
    }
}

// MARK: -- Tamanho fixo dos containers
enum ContainerSize {
    case small
    case medium
    case large
    
    var dimensions: (width: CGFloat, height: CGFloat) {
        switch self {
        case .small:
            return (158, 158)
        case .medium:
            return (UIScreen.main.bounds.width, 158)
        case .large:
            return (UIScreen.main.bounds.width, 354)
        }
    }
}
