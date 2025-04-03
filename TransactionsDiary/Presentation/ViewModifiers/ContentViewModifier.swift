//
//  ContentViewModifier.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import SwiftUI

struct ContentViewModifier: ViewModifier {
    let style: ContentViewStyle
    let backgroundType: BackgroundType // put as part of the style

    enum BackgroundType {
        case color
        case gradient
    }
    
    init(style: ContentViewStyle) {
        self.style = style
        backgroundType = style.colorId != nil ? .color : .gradient
    }

    func body(content: Content) -> some View {
        switch backgroundType {
        case .color:
            withBackgroundColor(content: content)
        case .gradient:
            withGradient(content: content)
        }
    }

    @ViewBuilder
    private func withBackgroundColor(content: Content) -> some View {
        content
            .background(Color(uiColor: .fromHexValue(style.colorId ?? "")))
            .cornerRadius(style.cornerRadius)
            .shadow(
                    color: Color(.fromHexValue(style.shadowColorId ?? "")),
                    radius: style.shadowRadius ?? 0
                )
    }

    @ViewBuilder
    private func withGradient(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [
                        style.gradientStartColor ?? "",
                        style.gradientEndColor ?? ""
                    ].map {
                        Color(uiColor: .fromHexValue($0))
                    },
                    startPoint: .top,
                    endPoint: .bottom
                ))
            .cornerRadius(style.cornerRadius)
            .shadow(
                    color: Color(.fromHexValue(style.shadowColorId ?? "")),
                    radius: style.shadowRadius ?? 0
                )
    }
}

extension View {
    @ViewBuilder
    func addBackgroundView(hasNavigationBar: Bool = true) -> some View {
        self
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .modifier(
                ContentViewModifier(
                    style: DefaultTheme().primaryBackgroundStyle()
                )
            )
            .if(hasNavigationBar) { content in
                content
                    .edgesIgnoringSafeArea(.bottom)
            } else: { content in
                content
                    .edgesIgnoringSafeArea(.all)
            }
    }

}
