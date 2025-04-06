//
//  NavigationBarViewModifier.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import SwiftUI

// TODO: set in coordinator before presenting vc
struct NavigationBarViewModifier: ViewModifier {
    let style: NavigationBarStyle
    let onTap: () -> Void
    
    init(
        style: NavigationBarStyle,
        onTap: @escaping () -> Void
    ) {
        self.style = style
        self.onTap = onTap
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
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
