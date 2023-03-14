//
//  Web3ClientImpl.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 26/1/23.
//

import Foundation
import web3
import BigInt

protocol Web3Client {
    // Read
    func getGas() async throws -> BigUInt?
    func getBalance(_ address: String) async throws -> BigUInt?
    func allowanceTransaction(transaction: EthereumTransaction) async throws -> BigUInt?
    func getNonce(_ address: String) async throws -> Int
    
    // Write
    func rawTransaction(account: EthereumAccount, transaction: EthereumTransaction) async throws -> String
}

class Web3ClientImpl: Web3Client {
    private(set) var client: EthereumClientProtocol!
    
    init(clientUrl: URL) {
        client = EthereumClient(url: clientUrl)
    }
    
    public func getGas() async throws -> BigUInt? {
        return try await client!.eth_gasPrice()
    }
    
    public func getBalance(_ address: String) async throws -> BigUInt? {
        return try await client!.eth_getBalance(address: EthereumAddress(address), block: .Latest)
    }
    
    public func getNonce(_ address: String) async throws -> Int {
        return try await client.eth_getTransactionCount(address: EthereumAddress(address), block: .Latest)
    }
    
    public func allowanceTransaction(transaction: EthereumTransaction) async throws -> BigUInt? {
        return await BigUInt(hex: try client!.eth_call(transaction, block: .Latest))
    }
    
    public func rawTransaction(account: EthereumAccount, transaction: EthereumTransaction) async throws -> String {
        return try await client.eth_sendRawTransaction(transaction, withAccount: account)
    }
}
