//
//  Theme.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import UIKit

// MARK: - Theme
protocol Theme {
    var primaryColor: String { get }
    var primaryCornerRadius: Double { get }
    var primaryBorderSize: Double { get }
    var primaryBorderColor: String? { get }
    var primaryShadowColor: String { get }
    var primaryShadowCornerRadius: Double { get }
    
    var secondaryColor: String { get }
    var secondaryCornerRadius: Double { get }
    var secondaryBorderSize: Double { get }
    var secondaryBorderColor: String? { get }
    var secondaryShadowColor: String? { get }
    var secondaryShadowCornerRadius: Double? { get }

    var headerColor: String { get }
    var headerCornerRadius: Double { get }
    var headerBorderSize: Double { get }
    var headerBorderColor: String? { get }
    var headerShadowColor: String? { get }
    var headerShadowCornerRadius: Double? { get }

    var fontName: String { get }
    var primaryFontSize: Double { get }
    var secondaryFontSize: Double { get }
    var titleFontSize: Double { get }
    var headerFontSize: Double { get }
    var header2FontSize: Double { get }

    var buttonCornerRadius: Double { get }
    var enabledButtonGradientStartColor: String { get }
    var enabledButtonGradientEndColor: String { get }
    var enabledButtonTextColor: String { get }
    var disabledButtonGradientStartColor: String { get }
    var disabledButtonGradientEndColor: String { get }
    var disabledButtonTextColor: String { get }

    var primaryTextColor: String { get }
    var secondaryTextColor: String { get }
    
    var backButtonImage: String { get }
    var dismissButtonImage: String { get }
}

// MARK: - DefaultTheme
struct DefaultTheme: Theme {
    var primaryColor: String = "#EFEFF2"
    var primaryCornerRadius: Double = 0
    var primaryBorderSize: Double = 0
    var primaryBorderColor: String? = nil
    var primaryShadowColor: String = "#B1AAAA"
    var primaryShadowCornerRadius: Double = 0
    var secondaryColor: String = "#F7F7FA"
    var secondaryCornerRadius: Double = 8
    var secondaryBorderSize: Double = 0
    var secondaryBorderColor: String? = nil
    var secondaryShadowColor: String? = "#B1AAAA"
    var secondaryShadowCornerRadius: Double? = 4
    var headerColor: String = "#FFFFFF"
    var headerCornerRadius: Double = 8
    var headerBorderSize: Double = 0
    var headerBorderColor: String? = nil
    var headerShadowColor: String? = "#B1AAAA"
    var headerShadowCornerRadius: Double? = 2
    var fontName: String = "SF Pro Display"
    var primaryFontSize: Double = 24
    var secondaryFontSize: Double = 18
    var titleFontSize: Double = 40
    var headerFontSize: Double = 25
    var header2FontSize: Double = 15
    var buttonCornerRadius: Double = 16
    var enabledButtonGradientStartColor: String = "#4316DB"
    var enabledButtonGradientEndColor: String = "#9076E7"
    var enabledButtonTextColor: String = "#FFFFFF"
    var disabledButtonGradientStartColor: String = "#bfc3c9"
    var disabledButtonGradientEndColor: String = "#dfe4eb"
    var disabledButtonTextColor: String = "#3d3e40"
    var primaryTextColor: String = "#2C2B2B"
    var secondaryTextColor: String = "#3C3A3A"
    var backButtonImage: String = "chevron.backward"
    var dismissButtonImage: String = "xmark"
}

// MARK: - Theme + Styles
extension Theme {
    func primaryTextStyle() -> TextStyle {
        TextStyle(
            colorId: primaryTextColor,
            fontId: fontName,
            fontSize: primaryFontSize
        )
    }

    func secondaryTextStyle() -> TextStyle {
        TextStyle(
            colorId: secondaryTextColor,
            fontId: fontName,
            fontSize: secondaryFontSize
        )
    }

    func header2TextStyle() -> TextStyle {
        TextStyle(
            colorId: secondaryTextColor,
            fontId: fontName,
            fontSize: header2FontSize
        )
    }

    func headerTextStyle() -> TextStyle {
        TextStyle(
            colorId: primaryTextColor,
            fontId: fontName,
            fontSize: headerFontSize
        )
    }

    func titleTextStyle() -> TextStyle {
        TextStyle(
            colorId: primaryTextColor,
            fontId: fontName,
            fontSize: titleFontSize
        )
    }

    func enabledButtonTextStyle() -> TextStyle {
        TextStyle(
            colorId: enabledButtonTextColor,
            fontId: fontName,
            fontSize: primaryFontSize
        )
    }

    func disabledButtonTextStyle() -> TextStyle {
        TextStyle(
            colorId: disabledButtonTextColor,
            fontId: fontName,
            fontSize: primaryFontSize
        )
    }

    func primaryBackgroundStyle() -> ContentViewStyle {
        ContentViewStyle(
            colorId: primaryColor,
            gradientStartColor: nil,
            gradientEndColor: nil,
            cornerRadius: primaryCornerRadius,
            borderColorId: primaryBorderColor,
            borderSize: primaryBorderSize,
            shadowColorId: primaryShadowColor,
            shadowRadius: primaryShadowCornerRadius
        )
    }

    func secondaryBackgroundStyle() -> ContentViewStyle {
        ContentViewStyle(
            colorId: secondaryColor,
            gradientStartColor: nil,
            gradientEndColor: nil,
            cornerRadius: secondaryCornerRadius,
            borderColorId: secondaryBorderColor,
            borderSize: secondaryBorderSize,
            shadowColorId: secondaryShadowColor,
            shadowRadius: secondaryShadowCornerRadius
        )
    }
    
    func enabledButtonBackgroundStyle() -> ContentViewStyle {
        ContentViewStyle(
            colorId: nil,
            gradientStartColor: enabledButtonGradientStartColor,
            gradientEndColor: enabledButtonGradientEndColor,
            cornerRadius: buttonCornerRadius,
            borderColorId: nil,
            borderSize: nil,
            shadowColorId: nil,
            shadowRadius: nil
        )
    }
    
    func disabledButtonBackgroundStyle() -> ContentViewStyle {
        ContentViewStyle(
            colorId: nil,
            gradientStartColor: disabledButtonGradientStartColor,
            gradientEndColor: disabledButtonGradientEndColor,
            cornerRadius: buttonCornerRadius,
            borderColorId: nil,
            borderSize: nil,
            shadowColorId: nil,
            shadowRadius: nil
        )
    }

    func headerBackgroundStyle() -> ContentViewStyle {
        ContentViewStyle(
            colorId: headerColor,
            gradientStartColor: nil,
            gradientEndColor: nil,
            cornerRadius: headerCornerRadius,
            borderColorId: headerBorderColor,
            borderSize: headerBorderSize,
            shadowColorId: headerShadowColor,
            shadowRadius: headerShadowCornerRadius
        )
    }

    func navigationBarStyle() -> NavigationBarStyle {
        NavigationBarStyle(
            titleStyle: primaryTextStyle(),
            backButtonImageName: backButtonImage,
            backButtonTintColorId: primaryTextColor
        )
    }

    func modalNavigationBarStyle() -> NavigationBarStyle {
        NavigationBarStyle(
            titleStyle: primaryTextStyle(),
            backButtonImageName: dismissButtonImage,
            backButtonTintColorId: primaryTextColor
        )
    }
}
