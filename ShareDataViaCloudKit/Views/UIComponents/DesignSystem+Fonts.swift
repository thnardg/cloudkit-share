//
//  DesignSystem+Fonts.swift
//  SwiftUIShareData
//
//  Created by Thayna Rodrigues on 25/10/24.
//

import SwiftUI

enum FontGroups: String {
    case title = "Baumans"
    case body = "Poppins"
}

struct FontStyles {
    static let largeTitle = Font.custom(FontGroups.title.rawValue, size: 45, relativeTo: .largeTitle)
    static let title1 = Font.custom(FontGroups.title.rawValue, size: 36, relativeTo: .title)
    static let title2 = Font.custom(FontGroups.title.rawValue, size: 30, relativeTo: .title2)
    static let title3 = Font.custom(FontGroups.title.rawValue, size: 20, relativeTo: .title3)
    static let title4 = Font.custom(FontGroups.title.rawValue, size: 16, relativeTo: .body)
    static let tags = Font.custom(FontGroups.body.rawValue, size: 12, relativeTo: .callout).bold()
    static let bodyRegular = Font.custom(FontGroups.body.rawValue, size: 17, relativeTo: .body)
    static let bodyDetails = Font.custom(FontGroups.body.rawValue, size: 14, relativeTo: .callout)
    static let bodyPreview = Font.custom(FontGroups.body.rawValue, size: 12, relativeTo: .footnote)
}
