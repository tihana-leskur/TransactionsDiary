//
//  TextViewModifier.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import SwiftUI

struct TextViewModifier: ViewModifier {
    let style: TextStyle
    
    init(style: TextStyle) {
        self.style = style
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(style.fontId, size: style.fontSize))
            .foregroundColor(Color(.fromHexValue(style.colorId)))
    }
}
