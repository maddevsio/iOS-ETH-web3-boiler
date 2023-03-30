import Foundation
import BigInt
import Web3Auth
import web3

protocol Web3ClientReadRepositoryProtocol {
    var web3ClientTransaction: Web3ClientFunctions { get }
    
    var web3Client: Web3Client? { get set }
    
    var signedAddress: String? { get set }
    var chainId: Int! { get set }
    
    func getGasPrise() async throws -> BigUInt?
    func getBalanceCurrentClient() async throws -> BigUInt?
    
    func getReceipt(hash: String) async throws -> EthereumTransactionReceipt?
    func allowance(owner: String, sender: String?, contract: String) async throws -> BigUInt?
}


/// Web3ClientBaseRepository contains only common functions for Web3Repository
/// And for the WalletConnectRepositorty
/// Created to avoid functions duplications
class Web3ClientReadRepository: Web3ClientReadRepositoryProtocol {
    public let web3ClientTransaction: Web3ClientFunctions
    
    public var web3Client: Web3Client?
    public var signedAddress: String?
    public var chainId: Int!
    
    public init(web3ClientTransaction: Web3ClientFunctions) {
        self.web3ClientTransaction = web3ClientTransaction
    }
    
    func getGasPrise() async throws -> BigUInt? {
        try await web3Client?.getGas()
    }
    
    func getBalanceCurrentClient() async throws -> BigUInt? {
        guard let signedAddress else {
            throw Web3ClientError.FromAddressNotFound
        }
        return try await web3Client?.getBalance(signedAddress)
    }
    
    func allowance(owner: String, sender: String?, contract: String) async throws -> BigUInt? {
        guard let signedAddress else {
            throw Web3ClientError.FromAddressNotFound
        }
        
        var transaction = try web3ClientTransaction.allowanceTransaction(from: signedAddress,
                                                                         owner: owner,
                                                                         sender: sender ?? signedAddress,
                                                                         contract: contract)
        transaction.chainId = chainId
        let result = try await web3Client?.readTransaction(transaction: transaction) ?? ""
        return BigUInt(hex: result)
    }
    
    func getReceipt(hash: String) async throws -> EthereumTransactionReceipt? {
        return try await web3Client?.transactionReceipt(hash: hash)
    }
}
