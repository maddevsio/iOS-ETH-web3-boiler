import Foundation
import web3
import BigInt

public struct Transfer: ABIFunction {
    public static let name = "transfer"
    public var gasPrice: BigUInt? = nil
    public var gasLimit: BigUInt? = nil
    public var contract: EthereumAddress // To address or contract address
    public let from: EthereumAddress?
    public let value: BigUInt

    public init(from: EthereumAddress,
                contract: EthereumAddress,
                value: BigUInt,
                gasPrice: BigUInt?,
                gasLimit: BigUInt?) {
        self.contract = contract
        self.from = from
        self.value = value
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(value)
    }
}
