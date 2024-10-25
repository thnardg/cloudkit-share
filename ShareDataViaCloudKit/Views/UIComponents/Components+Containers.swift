//
//  Components+Containers.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 24/10/24.
//

import SwiftUI

struct BaseContainer<Content: View>: View {
    var size: ContainerSize
    var content: () -> Content
    
    var body: some View {
        VStack {
            content()
                .frame(
                    maxWidth: size.isFixedWidth ? size.dimensions.width : .infinity,
                    minHeight: size.dimensions.height,
                    maxHeight: size.dimensions.height
                )
        }
        .background(Color.white)
        .cornerRadius(22)
    }
}

enum ContainerSize {
    case small
    case medium
    case large
    
    var dimensions: (width: CGFloat, height: CGFloat) {
        switch self {
        case .small:
            return (158, 158)
        case .medium:
            return (0, 158)
        case .large:
            return (0, 354)
        }
    }
    
    var isFixedWidth: Bool {
        switch self {
        case .small:
            return true
        case .medium, .large:
            return false
        }
    }
}
