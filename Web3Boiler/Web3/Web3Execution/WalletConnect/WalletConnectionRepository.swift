import Foundation
import BigInt
import Web3Auth
import web3

class WalletConnectionRepositoryImpl: Web3ClientReadRepository, Web3ClientWriteRepositoryProtocol {
    
    private let mainRouter: MainRouter
    private let configs: Configs
    
    private var walletConnect: WalletConnection
    
    private var wallet: WalletModel?
    
    init(mainRouter: MainRouter,
         configs: Configs,
         walletConnect: WalletConnection,
         web3ClientTransaction: Web3ClientFunctions) {
        self.walletConnect = walletConnect
        self.mainRouter = mainRouter
        self.configs = configs
        super.init(web3ClientTransaction: web3ClientTransaction)
        
        self.walletConnect.delegate = self
    }
    
    func connect(_ wallet: WalletModel, web3Config: Web3ClientConfig, completion: @escaping (Result<Void>) -> Void) {
        guard let baseUrl = web3Config.baseUrl,
              let key = configs.getKey(.alchemyKey),
              let clientUrl = URL(string: "\(baseUrl)\(key)") else {
            completion(.failure(Web3ClientError.EnvVariablesNotFound))
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
                    // TODO...
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout() async throws -> Bool {
        web3Client = nil
        signedAddress = nil
        do {
            try walletConnect.logout()
            return true
        } catch let error {
            throw error
        }
    }
    
    func transfer(to: String, value: BigUInt) async throws -> String? {
        guard let signedAddress = walletConnect.getCurrentAddress() else {
            throw Web3ClientError.FromAddressNotFound
        }
        var transaction = try web3ClientTransaction.transfer(from: signedAddress,
                                                             to: to,
                                                             value: value,
                                                             gasPrice: nil,
                                                             gasLimit: nil)
        transaction.chainId = chainId
        return try await withCheckedThrowingContinuation { continuation in
            walletConnect.signTransaction(transaction) { [weak self] result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .openWallet:
                    self?.mainRouter.open(URL(string: self?.wallet?.walletLink ?? "")!)
                }
            }
        }
    }
    
    func transferWithContract(to: String, contract: String, value: BigUInt) async throws -> String? {
        guard let signedAddress = walletConnect.getCurrentAddress() else {
            throw Web3ClientError.FromAddressNotFound
        }
        var transaction = try web3ClientTransaction.contractTransfer(from: signedAddress,
                                                                     to: to,
                                                                     contract: contract,
                                                                     value: value,
                                                                     gasPrice: nil,
                                                                     gasLimit: nil)
        transaction.chainId = chainId
        return try await withCheckedThrowingContinuation { continuation in
            walletConnect.sendTransactionWithData(transaction) { [weak self] result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .openWallet:
                    self?.mainRouter.open(URL(string: self?.wallet?.walletLink ?? "")!)
                }
            }
        }
    }
    
    func approve(to: String, contract: String, value: BigUInt) async throws -> String? {
        guard let signedAddress = walletConnect.getCurrentAddress() else {
            throw Web3ClientError.FromAddressNotFound
        }
        var transaction = try web3ClientTransaction.approveTransaction(from: signedAddress,
                                                                       to: to,
                                                                       contract: contract,
                                                                       value: value,
                                                                       gasPrice: nil,
                                                                       gasLimit: nil)
        transaction.chainId = chainId
        return try await withCheckedThrowingContinuation { continuation in
            walletConnect.sendTransactionWithData(transaction) { [weak self] result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .openWallet:
                    self?.mainRouter.open(URL(string: self?.wallet?.walletLink ?? "")!)
                }
            }
        }
    }
    
    func transferFrom(sender: String, recipient: String, contract: String, value: BigUInt) async throws -> String? {
        guard let signedAddress = walletConnect.getCurrentAddress() else {
            throw Web3ClientError.FromAddressNotFound
        }
        var transaction = try web3ClientTransaction.transferFromTransaction(from: signedAddress,
                                                                            sender: sender,
                                                                            recipient: recipient,
                                                                            contract: contract,
                                                                            value: value,
                                                                            gasPrice: nil,
                                                                            gasLimit: nil)
        transaction.chainId = chainId
        return try await withCheckedThrowingContinuation { continuation in
            walletConnect.sendTransactionWithData(transaction) { [weak self] result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .openWallet:
                    self?.mainRouter.open(URL(string: self?.wallet?.walletLink ?? "")!)
                }
            }
        }
    }
}

extension WalletConnectionRepositoryImpl: WalletConnectionDelegate {
    func failedToConnect() {
        print("failedToConnect")
    }
    
    func didConnect() {
        signedAddress = walletConnect.getCurrentAddress()
        print("didConnect")
    }
    
    func didDisconnect() {
        print("didDisconnect")
    }
}
