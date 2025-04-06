//
//  ButtonItem.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/6/25.
//

import Foundation

// Data models on UI Layer
class ButtonItem {
    let content: String
    var isEnabled: Bool
    
    init(content: String, isEnabled: Bool = false) {
        self.content = content
        self.isEnabled = isEnabled
    }
}
