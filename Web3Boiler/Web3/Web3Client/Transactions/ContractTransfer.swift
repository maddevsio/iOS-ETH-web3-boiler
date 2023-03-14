//
//  ContractTransfer.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 16/1/23.
//

import Foundation
import web3
import BigInt

public struct ContractTransfer: ABIFunction {
    public static let name = "transfer"
    public var gasPrice: BigUInt? = nil
    public var gasLimit: BigUInt? = nil
    public var contract: EthereumAddress
    public let from: EthereumAddress?
    public let to: EthereumAddress
    public let value: BigUInt

    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                to: EthereumAddress,
                value: BigUInt,
                gasPrice: BigUInt?,
                gasLimit: BigUInt?) {
        self.contract = contract
        self.from = from
        self.to = to
        self.value = value
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(to)
        try encoder.encode(value)
    }
}
