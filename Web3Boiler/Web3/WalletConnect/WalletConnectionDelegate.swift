//
//  WalletConnectionDelegate.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 30/12/22.
//

import Foundation

protocol WalletConnectionDelegate: AnyObject {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}
