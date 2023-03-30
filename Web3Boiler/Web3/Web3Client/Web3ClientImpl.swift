import Foundation
import web3
import BigInt

protocol Web3Client {
    // Read
    func getGas() async throws -> BigUInt?
    func getBalance(_ address: String) async throws -> BigUInt?
    func readTransaction(transaction: EthereumTransaction) async throws -> String?
    func getNonce(_ address: String) async throws -> Int
    func transactionReceipt(hash: String) async throws -> EthereumTransactionReceipt
    
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
    
    public func readTransaction(transaction: EthereumTransaction) async throws -> String? {
        return try await client!.eth_call(transaction, block: .Latest)
    }
    
    public func rawTransaction(account: EthereumAccount, transaction: EthereumTransaction) async throws -> String {
        return try await client.eth_sendRawTransaction(transaction, withAccount: account)
    }
    
    public func transactionReceipt(hash: String) async throws -> EthereumTransactionReceipt {
        return try await client.eth_getTransactionReceipt(txHash: hash)
    }
}
