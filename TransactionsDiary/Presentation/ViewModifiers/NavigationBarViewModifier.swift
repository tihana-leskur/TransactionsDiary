//
//  NavigationBarViewModifier.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import SwiftUI

struct NavigationBarViewModifier: ViewModifier {
    let title: String
    let style: NavigationBarStyle
    let onTap: () -> Void
    
    init(
        title: String,
        style: NavigationBarStyle,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.onTap = onTap
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(title)
                            .modifier(
                                TextViewModifier(
                                    style: style.titleStyle
                                )
                            )
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        onTap()
                    } label: {
                        Image(systemName: style.backButtonImageName)
                            .renderingMode(.template)
                            .foregroundColor(
                                Color(
                                    uiColor: .fromHexValue(style.backButtonTintColorId)
                                )
                            )
                    }
                }
            }
    }
}
