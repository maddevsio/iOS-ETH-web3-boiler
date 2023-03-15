import Foundation
import Web3Auth
import BigInt

protocol Web3ClientRepository {
    func connect(_ wallet: WalletModel, web3Config: Web3ClientConfig, completion: @escaping (Result<String?>) -> Void) // Connect with existing wallet
    func login(_ provider: Web3AuthProvider, web3Config: Web3ClientConfig, completion: @escaping (Result<String?>) -> Void) // Connect with provider via social accounts
    
    func getGasPrise(completion: @escaping (Result<BigUInt?>) -> Void)
    func getBalanceCurrentClient(completion: @escaping (Result<BigUInt?>) -> Void)
    func transfer(to: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void)
    func transferWithContract(to: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void)
    func approve(to: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void)
    func allowance(owner: String, sender: String?, contract: String, completion: @escaping (Result<BigUInt?>) -> Void)
    func transferFrom(sender: String, recipient: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void)
}

extension Web3ClientRepository {
    func connect(_ wallet: WalletModel, web3Config: Web3ClientConfig, completion: @escaping (Result<String?>) -> Void) {}
    func login(_ provider: Web3AuthProvider, web3Config: Web3ClientConfig, completion: @escaping (Result<String?>) -> Void) {}
}
