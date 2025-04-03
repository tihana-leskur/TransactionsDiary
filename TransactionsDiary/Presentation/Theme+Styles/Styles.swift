//
//  Styles.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Foundation

// MARK: - ContentViewStyle
struct ContentViewStyle {
    let colorId: String?
    let gradientStartColor: String?
    let gradientEndColor: String?
    let cornerRadius: Double
    let borderColorId: String?
    let borderSize: Double?
    let shadowColorId: String?
    let shadowRadius: Double?
}

// MARK: - TextStyle
struct TextStyle {
    let colorId: String
    let fontId: String
    let fontSize: CGFloat
    // add alignemnt, line limit etc.
}

// MARK: - NavigationBarStyle
struct NavigationBarStyle {
    let titleStyle: TextStyle
    let backButtonImageName: String
    let backButtonTintColorId: String
}
