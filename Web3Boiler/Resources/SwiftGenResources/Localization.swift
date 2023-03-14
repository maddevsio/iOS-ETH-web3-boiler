// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {

  internal enum Common {
    /// Cancel
    internal static let cancel = Localization.tr("Localizable", "common.cancel")
    /// Close
    internal static let close = Localization.tr("Localizable", "common.close")
    /// Done
    internal static let done = Localization.tr("Localizable", "common.done")
    /// Ok
    internal static let ok = Localization.tr("Localizable", "common.ok")
    /// Retry
    internal static let retry = Localization.tr("Localizable", "common.retry")
    /// Select
    internal static let select = Localization.tr("Localizable", "common.select")
    /// View
    internal static let view = Localization.tr("Localizable", "common.view")
  }

  internal enum Debugging {
    /// Allowance Transaction
    internal static let allowance = Localization.tr("Localizable", "debugging.allowance")
    /// Approve Transaction
    internal static let approve = Localization.tr("Localizable", "debugging.approve")
    /// Get balance for current address
    internal static let balanceCurrentAddress = Localization.tr("Localizable", "debugging.balanceCurrentAddress")
    /// Wallet connect meta mask
    internal static let connectWallet = Localization.tr("Localizable", "debugging.connectWallet")
    /// Sign Transfer Contract Transaction
    internal static let contractTransaction = Localization.tr("Localizable", "debugging.contractTransaction")
    /// Create Proposal
    internal static let createProposal = Localization.tr("Localizable", "debugging.createProposal")
    /// Get gas price
    internal static let gasPrice = Localization.tr("Localizable", "debugging.gasPrice")
    /// Invite Member
    internal static let inviteMember = Localization.tr("Localizable", "debugging.inviteMember")
    /// Debugging screen
    internal static let title = Localization.tr("Localizable", "debugging.title")
    /// Sign Transfer Transaction
    internal static let transaction = Localization.tr("Localizable", "debugging.transaction")
    /// Transfer from Transaction
    internal static let transferFrom = Localization.tr("Localizable", "debugging.transferFrom")
    /// Vote Proposal
    internal static let voteProposal = Localization.tr("Localizable", "debugging.voteProposal")
    /// Web3Auth account
    internal static let web3Account = Localization.tr("Localizable", "debugging.web3Account")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
