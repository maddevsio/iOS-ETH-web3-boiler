//
//  WalletConnectError.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 30/12/22.
//

import Foundation

public enum WalletConnectError: Error {
    case connectionError
    case failedToGetCurrentAddress
    case transactionFailed(_ message: String)
    case transactionResponseError
}
