//
//  OnlyTextComponentView.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import SwiftUI

struct OnlyTextComponentView: View {
    let item: OnlyTextComponent
    let height: Double
    let width: Double?
    let textAlignement: Alignment
    let textPadding: Double // [edge: value]
    let contentViewPadding: Double // [edge: value]
    
    var body: some View {
        Text(item.content)
            .modifier(TextViewModifier(style: item.textStyle))
            .frame(
                maxWidth: width ?? .infinity,
                maxHeight: height,
                alignment: textAlignement
            )
            .padding(
                [.leading, .trailing],
                textPadding
            )
            .if(item.contentViewStyle != nil) {
                $0.modifier(
                    ContentViewModifier(style: item.contentViewStyle!)
                )
            }
            .padding(
                [.leading, .trailing],
                contentViewPadding
            )
    }
}

#Preview {
    VStack {
        OnlyTextComponentView(
            item: .init(
                id: UUID(),
                content: "title",
                textStyle: DefaultTheme()
                    .titleTextStyle(),
                contentViewStyle: nil
            ) { },
            height: 70,
            width: nil,
            textAlignement: .leading,
            textPadding: 8,
            contentViewPadding: 16
        )
        OnlyTextComponentView(
            item: .init(
                id: UUID(),
                content: "header",
                textStyle: DefaultTheme()
                    .headerTextStyle(),
                contentViewStyle: nil
            ) { },
            height: 60,
            width: nil,
            textAlignement: .leading,
            textPadding: 8,
            contentViewPadding: 16
        )
        OnlyTextComponentView(
            item: .init(
                id: UUID(),
                content: "text primary content secondary",
                textStyle: DefaultTheme()
                    .primaryTextStyle(),
                contentViewStyle: DefaultTheme()
                    .secondaryBackgroundStyle()
            ) { },
            height: 120,
            width: 150,
            textAlignement: .leading,
            textPadding: 8,
            contentViewPadding: 16
        )
        OnlyTextComponentView(
            item: .init(
                id: UUID(),
                content: "text secondary content secondary",
                textStyle: DefaultTheme()
                    .secondaryTextStyle(),
                contentViewStyle: DefaultTheme()
                    .secondaryBackgroundStyle()
            ) { },
            height: 50,
            width: nil,
            textAlignement: .center,
            textPadding: 8,
            contentViewPadding: 16
        )
        OnlyTextComponentView(
            item: .init(
                id: UUID(),
                content: "enabled button",
                textStyle: DefaultTheme()
                    .enabledButtonTextStyle(),
                contentViewStyle: DefaultTheme()
                    .enabledButtonBackgroundStyle()
            ) { },
            height: 50,
            width: nil,
            textAlignement: .center,
            textPadding: 8,
            contentViewPadding: 16
        )
        OnlyTextComponentView(
            item: .init(
                id: UUID(),
                content: "disabled button",
                textStyle: DefaultTheme()
                    .disabledButtonTextStyle(),
                contentViewStyle: DefaultTheme()
                    .disabledButtonBackgroundStyle()
            ) { },
            height: 50,
            width: nil,
            textAlignement: .center,
            textPadding: 8,
            contentViewPadding: 16
        )
        Spacer()
    }
    .modifier(
        ContentViewModifier(
            style: DefaultTheme().primaryBackgroundStyle()
        )
    )
}
