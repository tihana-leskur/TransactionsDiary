//
//  ComponentItem.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Foundation

struct ComponentItem: Identifiable {
    let id: UUID
    let content: String
    let onTap: () -> Void

    static let empty = ComponentItem(
        id: UUID(),
        content: "",
        onTap: {}
    )
}

struct ButtonItem {
    let content: String
    let isEnabled: Bool
    
    static let empty = ButtonItem(
        content: "",
        isEnabled: false
    )
}
