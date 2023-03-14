//
//  WalletConnectResult.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 10/3/23.
//

import Foundation

public enum WalletConnectResult<T> {
    case success(_ response: T)
    case failure(_ error: WalletConnectError)
    case openWallet
}
