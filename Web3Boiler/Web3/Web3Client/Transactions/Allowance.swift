import Foundation
import web3
import BigInt

public struct Allowance: ABIFunction {
    public static let name = "allowance"
    public let gasPrice: BigUInt? = nil
    public let gasLimit: BigUInt? = nil
    public var contract: EthereumAddress
    public let from: EthereumAddress?
    public let owner: EthereumAddress
    public let sender: EthereumAddress

    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                owner: EthereumAddress,
                sender: EthereumAddress) {
        self.contract = contract
        self.from = from
        self.owner = owner
        self.sender = sender
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(owner)
        try encoder.encode(sender)
    }
}
