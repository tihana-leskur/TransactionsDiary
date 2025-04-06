//
//  ButtonItem.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/6/25.
//

import Foundation
import SwiftUI

// Data models on UI Layer
class ButtonItem {
    var content: String
    var isEnabled: Bool

    init(
        content: String,
        isEnabled: Bool
    ) {
        self.content = content
        self.isEnabled = isEnabled
    }
}
