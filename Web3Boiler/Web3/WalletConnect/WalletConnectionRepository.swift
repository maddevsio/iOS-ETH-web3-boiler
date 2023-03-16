import Foundation
import BigInt
import Web3Auth

class WalletConnectionRepositoryImpl: Web3ClientRepository {
    private let mainRouter: MainRouter
    private let configs: Configs
    private let web3ClientTransaction: Web3ClientTransaction
    
    private var walletConnect: WalletConnection
    private var web3Client: Web3Client?
    
    private var wallet: WalletModel?
    
    init(mainRouter: MainRouter,
         configs: Configs,
         walletConnect: WalletConnection,
         web3ClientTransaction: Web3ClientTransaction) {
        self.walletConnect = walletConnect
        self.web3ClientTransaction = web3ClientTransaction
        self.mainRouter = mainRouter
        self.configs = configs
        
        self.walletConnect.delegate = self
    }
    
    public func connect(_ wallet: WalletModel, web3Config: Web3ClientConfig, completion: @escaping (Result<String?>) -> Void) {
        guard let baseUrl = web3Config.baseUrl,
              let key = configs.getKey(.alchemyKey),
              let clientUrl = URL(string: "\(baseUrl)\(key)") else {
            completion(.failure(Web3ClientError.EnvKeysMissed))
            return
        }
        
        web3Client = Web3ClientImpl(clientUrl: clientUrl)
        self.wallet = wallet
        walletConnect.connect { [weak self] result in
            switch result {
            case .success(let connectionPart):
                if let fullUrl = wallet.connectLink(connectionPart: connectionPart) {
                    self?.mainRouter.open(fullUrl)
                } else {
                    // TODO handle empty connection link
                }
                completion(.success(walletConnect.getCurrentAddress()))
            case .failure(let error):
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
                guard let signedAddress = walletConnect.getCurrentAddress() else {
                    throw Web3ClientError.FromAddressNotFound
                }
                let balance = try await web3Client?.getBalance(signedAddress)
                completion(.success(balance))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func transfer(to: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void) {
        do {
            guard let signedAddress = walletConnect.getCurrentAddress() else {
                throw Web3ClientError.FromAddressNotFound
            }
            let transaction = try web3ClientTransaction.transfer(from: signedAddress,
                                                                 to: to,
                                                                 value: value,
                                                                 gasPrice: nil,
                                                                 gasLimit: nil)
            walletConnect.signTransaction(transaction) { [weak self] result in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                case .openWallet:
                    self?.mainRouter.open(URL(string: self?.wallet?.walletLink ?? "")!)
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func transferWithContract(to: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void) {
        do {
            guard let signedAddress = walletConnect.getCurrentAddress() else {
                throw Web3ClientError.FromAddressNotFound
            }
            let transaction = try web3ClientTransaction.contractTransfer(from: signedAddress,
                                                                         to: to,
                                                                         contract: contract,
                                                                         value: value,
                                                                         gasPrice: nil,
                                                                         gasLimit: nil)
            walletConnect.signContractTransaction(transaction) { [weak self] result in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                case .openWallet:
                    self?.mainRouter.open(URL(string: self?.wallet?.walletLink ?? "")!)
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func approve(to: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void) {
        do {
            guard let signedAddress = walletConnect.getCurrentAddress() else {
                throw Web3ClientError.FromAddressNotFound
            }
            let transaction = try web3ClientTransaction.approveTransaction(from: signedAddress,
                                                                           to: to,
                                                                           contract: contract,
                                                                           value: value,
                                                                           gasPrice: nil,
                                                                           gasLimit: nil)
            
            walletConnect.approveTransaction(transaction) { [weak self] result in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                case .openWallet:
                    self?.mainRouter.open(URL(string: self?.wallet?.walletLink ?? "")!)
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func allowance(owner: String, sender: String?, contract: String, completion: @escaping (Result<BigUInt?>) -> Void) {
        Task {
            guard let signedAddress = walletConnect.getCurrentAddress() else {
                throw Web3ClientError.FromAddressNotFound
            }
            let transaction = try web3ClientTransaction.allowanceTransaction(from: signedAddress,
                                                                             owner: owner,
                                                                             sender: sender ?? signedAddress,
                                                                             contract: contract)
            
            let allowanceBalance = try await web3Client?.allowanceTransaction(transaction: transaction)
            completion(.success(allowanceBalance))
        }
    }
    
    
    func transferFrom(sender: String, recipient: String, contract: String, value: BigUInt, completion: @escaping (Result<String?>) -> Void) {
        do {
            // From should be from address that create approve
            guard let signedAddress = walletConnect.getCurrentAddress() else {
                throw Web3ClientError.FromAddressNotFound
            }
            let transaction = try web3ClientTransaction.transferFromTransaction(from: signedAddress,
                                                                                sender: sender,
                                                                                recipient: recipient,
                                                                                contract: contract,
                                                                                value: value,
                                                                                gasPrice: nil,
                                                                                gasLimit: nil)
            walletConnect.transferFromTransaction(transaction) { [weak self] result in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                case .openWallet:
                    self?.mainRouter.open(URL(string: self?.wallet?.walletLink ?? "")!)
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
}

extension WalletConnectionRepositoryImpl: WalletConnectionDelegate {
    func failedToConnect() {
        print("failedToConnect")
    }
    
    func didConnect() {
        print("didConnect")
    }
    
    func didDisconnect() {
        print("didDisconnect")
    }
}
