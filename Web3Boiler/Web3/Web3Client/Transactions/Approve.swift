import Foundation
import web3
import BigInt

public struct Approve: ABIFunction {
    public static let name = "approve"
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
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(to)
        try encoder.encode(value)
    }
}
