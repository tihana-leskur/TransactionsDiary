//
//  ComponentItem.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Foundation

// General item; TODO: tihana rename, clarify
struct ComponentItem: Identifiable {
    let id: UUID
    let content: String

    static let empty = ComponentItem(
        id: UUID(),
        content: ""
    )
}
