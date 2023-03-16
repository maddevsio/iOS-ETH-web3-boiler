import Foundation
import web3
import Web3Auth
import BigInt

class Web3RepositoryImpl: Web3ClientRepository {
    enum Constants {
        static let baseGasLimit: Double = 21000
    }
    
    private let configs: Configs
    private let web3Auth: Web3AuthClient
    private let web3ClientTransaction: Web3ClientTransaction
    
    private var web3Client: Web3Client?
    private var account: EthereumAccount?
    private var storage: EthKeyStorage?
    private var web3Config: Web3ClientConfig!
    
    init(configs: Configs,
         web3Auth: Web3AuthClient,
         web3ClientTransaction: Web3ClientTransaction,
         storage: EthKeyStorage) {
        self.configs = configs
        self.web3Auth = web3Auth
        self.web3ClientTransaction = web3ClientTransaction
        self.storage = storage
    }
    
    public func login(_ provider: Web3AuthProvider, web3Config: Web3ClientConfig, completion: @escaping (Result<String?>) -> Void) {
        guard let baseUrl = web3Config.baseUrl,
              let key = configs.getKey(.alchemyKey),
              let clientUrl = URL(string: "\(baseUrl)\(key)") else {
            completion(.failure(Web3ClientError.EnvKeysMissed))
            return
        }
        
        self.web3Config = web3Config
        Task {
            do {
                if storage?.getPrivateKey() == nil {
                    let userState = try await web3Auth.login(provider)
                    guard let key = userState?.privKey?.web3.hexData else {
                        return
                    }
                    try storage?.storePrivateKey(key: key)
                }
                account = try EthereumAccount(keyStorage: storage!)
                web3Client = Web3ClientImpl(clientUrl: clientUrl)
                completion(.success(account?.address.value))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func getGasPrise(completion: @escaping (Result<BigUInt?>) -> Void) {
        Task {
            do {
                let gasPrice = try await web3Client?.getGas()
                completion(.success(gasPrice))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func getBalanceCurrentClient(completion: @escaping (Result<BigUInt?>) -> Void) {
        Task {
            do {
                guard let myAddress = account?.address else {
                    throw Web3ClientError.FromAddressNotFound
                }
                let balance = try await web3Client?.getBalance(myAddress.value)
                completion(.success(balance))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func transfer(to: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void) {
        Task {
            do {
                guard let account else {
                    throw Web3ClientError.FromAddressNotFound
                }
                let gasPrice = try await web3Client?.getGas()
                let gasLimit = getGasLimit(gasPrice)
                var transaction = try web3ClientTransaction.transfer(from: account.address.value,
                                                                     to: to,
                                                                     value: value,
                                                                     gasPrice: gasPrice!,
                                                                     gasLimit: gasLimit)
                transaction.chainId = web3Config.chainId
                let txHash = try await web3Client?.rawTransaction(account: account, transaction: transaction)
                completion(.success(txHash))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func transferWithContract(to: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void) {
        Task {
            do {
                guard let account else {
                    throw Web3ClientError.FromAddressNotFound
                }
                let gasPrice = try await web3Client?.getGas()
                let gasLimit = getGasLimit(gasPrice)
                var transaction = try web3ClientTransaction.contractTransfer(from: account.address.value,
                                                                             to: to,
                                                                             contract: contract,
                                                                             value: value,
                                                                             gasPrice: gasPrice!,
                                                                             gasLimit: gasLimit)
                transaction.chainId = web3Config.chainId
                let txHash = try await web3Client?.rawTransaction(account: account, transaction: transaction)
                completion(.success(txHash))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func approve(to: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void) {
        Task {
            do {
                guard let account else {
                    throw Web3ClientError.FromAddressNotFound
                }
                let gasPrice = try await web3Client?.getGas()
                let gasLimit = getGasLimit(gasPrice)
                var transaction = try web3ClientTransaction.approveTransaction(from: account.address.value,
                                                                               to: to,
                                                                               contract: contract,
                                                                               value: value,
                                                                               gasPrice: gasPrice!,
                                                                               gasLimit: gasLimit)
                transaction.chainId = web3Config.chainId
                let txHash = try await web3Client?.rawTransaction(account: account, transaction: transaction)
                completion(.success(txHash))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func allowance(owner: String, sender: String?, contract: String, completion: @escaping (Result<BigUInt?>) -> Void) {
        Task {
            guard let account else {
                throw Web3ClientError.FromAddressNotFound
            }
            let transaction = try web3ClientTransaction.allowanceTransaction(from: account.address.value,
                                                                             owner: owner,
                                                                             sender: sender ?? account.address.value,
                                                                             contract: contract)
            let allowanceBalance = try await web3Client?.allowanceTransaction(transaction: transaction)
            completion(.success(allowanceBalance))
        }
    }
    
    func transferFrom(sender: String, recipient: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void) {
        Task {
            do {
                guard let account else {
                    throw Web3ClientError.FromAddressNotFound
                }
                let gasPrice = try await web3Client?.getGas()
                let gasLimit = getGasLimit(gasPrice)
                var transaction = try web3ClientTransaction.transferFromTransaction(from: account.address.value,
                                                                                    sender: sender,
                                                                                    recipient: recipient,
                                                                                    contract: contract,
                                                                                    value: value,
                                                                                    gasPrice: gasPrice!,
                                                                                    gasLimit: gasLimit)
                transaction.chainId = web3Config.chainId
                let txHash = try await web3Client?.rawTransaction(account: account, transaction: transaction)
                completion(.success(txHash))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    private func getGasLimit(_ gasPrice: BigUInt?) -> BigUInt {
        guard let gasPrice else {
            return BigUInt(Constants.baseGasLimit * 10)
        }
        
        let gasLimit = TorusWeb3Utils.toEther(Gwie: gasPrice) * Constants.baseGasLimit
        return BigUInt(gasLimit)
    }
}
