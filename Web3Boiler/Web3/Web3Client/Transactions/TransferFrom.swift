//
//  TransferFrom.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 18/1/23.
//

import Foundation
import web3
import BigInt

public struct TransferFrom: ABIFunction {
    public static let name = "transferFrom"
    public var gasPrice: BigUInt? = nil
    public var gasLimit: BigUInt? = nil
    public var contract: EthereumAddress
    public let from: EthereumAddress? // Should be same as sender
    public let sender: EthereumAddress
    public let recipient: EthereumAddress
    public let value: BigUInt

    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                sender: EthereumAddress,
                recipient: EthereumAddress,
                value: BigUInt,
                gasPrice: BigUInt?,
                gasLimit: BigUInt?) {
        self.contract = contract
        self.from = from
        self.sender = sender
        self.recipient = recipient
        self.value = value
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(sender)
        try encoder.encode(recipient)
        try encoder.encode(value)
    }
}
