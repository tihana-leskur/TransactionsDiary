// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  /// Add Invoice
  internal static let addInvoice = Strings.tr("Localizable", "addInvoice", fallback: "Add Invoice")
  /// Add Receipt
  internal static let addReceipt = Strings.tr("Localizable", "addReceipt", fallback: "Add Receipt")
  /// Add Transaction Details
  internal static let addTransactionDetailsTitle = Strings.tr("Localizable", "addTransactionDetailsTitle", fallback: "Add Transaction Details")
  /// All transactions
  internal static let allTransactionsTitle = Strings.tr("Localizable", "allTransactionsTitle", fallback: "All transactions")
  /// Confirm
  internal static let confirmAction = Strings.tr("Localizable", "confirmAction", fallback: "Confirm")
  /// Continue
  internal static let continueAction = Strings.tr("Localizable", "continueAction", fallback: "Continue")
  /// Enter amount
  internal static let enterAmount = Strings.tr("Localizable", "enterAmount", fallback: "Enter amount")
  /// Hello
  internal static let hello = Strings.tr("Localizable", "hello", fallback: "Hello")
  /// Last Transactions
  internal static let lastTransactions = Strings.tr("Localizable", "lastTransactions", fallback: "Last Transactions")
  /// Retake Photo
  internal static let retakePhoto = Strings.tr("Localizable", "retakePhoto", fallback: "Retake Photo")
  /// Localizable.strings
  ///   TransactionsDiary
  /// 
  ///   Created by tihana leskur on 4/6/25.
  internal static let saveAction = Strings.tr("Localizable", "saveAction", fallback: "Save")
  /// See All Transactions
  internal static let seeAllTransactions = Strings.tr("Localizable", "seeAllTransactions", fallback: "See All Transactions")
  /// Take Photo
  internal static let takePhoto = Strings.tr("Localizable", "takePhoto", fallback: "Take Photo")
  /// Add transaction image
  internal static let takeTransactionImageTitle = Strings.tr("Localizable", "takeTransactionImageTitle", fallback: "Add transaction image")
  /// Transaction Details
  internal static let transactionDetailsTitle = Strings.tr("Localizable", "transactionDetailsTitle", fallback: "Transaction Details")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
