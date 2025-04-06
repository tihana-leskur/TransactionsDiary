//
//  OnlyTextComponent.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Foundation

struct OnlyTextComponent: Identifiable {
    let id: UUID
    let content: String
    let textStyle: TextStyle
    let contentViewStyle: ContentViewStyle?

    init(
        id: UUID = UUID(),
        content: String,
        textStyle: TextStyle,
        contentViewStyle: ContentViewStyle? = nil
    ) {
        self.id = id
        self.content = content
        self.textStyle = textStyle
        self.contentViewStyle = contentViewStyle
    }

    static let empty = OnlyTextComponent(
        id: UUID(),
        content: "",
        textStyle: .init(colorId: "", fontId: "", fontSize: 0)
    )
}
