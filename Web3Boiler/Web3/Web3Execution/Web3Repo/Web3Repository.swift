import Foundation
import web3
import Web3Auth
import BigInt

class Web3RepositoryImpl: Web3ClientReadRepository, Web3ClientWriteRepositoryProtocol {
    enum Constants {
        static let baseGasLimit: Double = 21000
    }
    
    private let configs: Configs
    private let web3Auth: Web3AuthClient
    private var account: EthereumAccount? {
        didSet {
            signedAddress = account?.address.value
        }
    }
    private var storage: EthKeyStorage?
    
    init(configs: Configs,
         web3Auth: Web3AuthClient,
         web3ClientTransaction: Web3ClientFunctions,
         storage: EthKeyStorage) {
        self.configs = configs
        self.web3Auth = web3Auth
        self.storage = storage
        super.init(web3ClientTransaction: web3ClientTransaction)
    }
    
    func login(_ provider: Web3AuthProvider, web3Config: Web3ClientConfig, completion: @escaping (Result<Void>) -> Void) {
        guard let baseUrl = web3Config.baseUrl,
              let key = configs.getKey(.alchemyKey),
              let clientUrl = URL(string: "\(baseUrl)\(key)") else {
            completion(.failure(Web3ClientError.EnvVariablesNotFound))
            return
        }
        
        self.chainId = web3Config.chainId
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
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func logout() async throws -> Bool {
        storage?.secureStorage.key = nil
        web3Client = nil
        account = nil
        return await web3Auth.logout()
    }
    
    func transfer(to: String, value: BigUInt) async throws -> String? {
        guard let account else {
            throw Web3ClientError.FromAddressNotFound
        }
        let gasPrice = try await web3Client?.getGas()
        var transaction = try web3ClientTransaction.transfer(from: account.address.value,
                                                             to: to,
                                                             value: value,
                                                             gasPrice: gasPrice,
                                                             gasLimit: getGasLimit())
        transaction.chainId = chainId
        let txHash = try await web3Client?.rawTransaction(account: account, transaction: transaction)
        return txHash
    }
    
    func transferWithContract(to: String, contract: String, value: BigUInt) async throws -> String? {
        guard let account else {
            throw Web3ClientError.FromAddressNotFound
        }
        let gasPrice = try await web3Client?.getGas()
        var transaction = try web3ClientTransaction.contractTransfer(from: account.address.value,
                                                                     to: to,
                                                                     contract: contract,
                                                                     value: value,
                                                                     gasPrice: gasPrice,
                                                                     gasLimit: getGasLimit())
        transaction.chainId = chainId
        let txHash = try await web3Client?.rawTransaction(account: account, transaction: transaction)
        return txHash
    }
    
    func approve(to: String, contract: String, value: BigUInt) async throws -> String? {
        guard let account else {
            throw Web3ClientError.FromAddressNotFound
        }
        let gasPrice = try await web3Client?.getGas()
        var transaction = try web3ClientTransaction.approveTransaction(from: account.address.value,
                                                                       to: to,
                                                                       contract: contract,
                                                                       value: value,
                                                                       gasPrice: gasPrice,
                                                                       gasLimit: getGasLimit())
        transaction.chainId = chainId
        let txHash = try await web3Client?.rawTransaction(account: account, transaction: transaction)
        return txHash
    }
    
    func transferFrom(sender: String, recipient: String, contract: String, value: BigUInt) async throws -> String? {
        guard let account else {
            throw Web3ClientError.FromAddressNotFound
        }
        let gasPrice = try await web3Client?.getGas()
        var transaction = try web3ClientTransaction.transferFromTransaction(from: account.address.value,
                                                                            sender: sender,
                                                                            recipient: recipient,
                                                                            contract: contract,
                                                                            value: value,
                                                                            gasPrice: gasPrice,
                                                                            gasLimit: getGasLimit())
        transaction.chainId = chainId
        let txHash = try await web3Client?.rawTransaction(account: account, transaction: transaction)
        return txHash
    }
}

extension Web3RepositoryImpl {
    private func getGasLimit() -> BigUInt {
        return BigUInt(Constants.baseGasLimit * 10)
    }
}
