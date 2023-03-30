import Foundation
import WalletConnectSwift
import web3
import BigInt

protocol WalletConnection {
    var delegate: WalletConnectionDelegate? { get set }
    
    func connect(_ completion: (Result<String, WalletConnectError>) -> Void)
    func logout() throws
    func reconnectIfNeeded()
    func getCurrentAddress() -> String?
    
    func signTransaction(_ transaction: EthereumTransaction, completion: @escaping WalletConnectionImpl.WCResult)
    
    func sendTransactionWithData(_ transaction: EthereumTransaction, completion: @escaping WalletConnectionImpl.WCResult)
}

class WalletConnectionImpl: WalletConnection {
    public typealias WCResult = (WalletConnectResult<String>) -> Void
    
    private let userDefaults: UserDefaultsStorage
    private let configs: Configs
    
    private var client: Client?
    private var session: Session?
    private var wcUrl: WCURL?
    public weak var delegate: WalletConnectionDelegate?
    
    init(userDefaults: UserDefaultsStorage,
         configs: Configs) {
        self.userDefaults = userDefaults
        self.configs = configs
    }
    
    public func connect(_ completion: (Result<String, WalletConnectError>) -> Void) {
        guard let bridgeURL = configs.getUrl(.bridgeTestURL),
              let clientURL = configs.getUrl(.projURL) else {
            completion(.failure(.connectionError))
            return
        }
        
        wcUrl = WCURL(topic: UUID().uuidString,
                      bridgeURL: bridgeURL,
                      key: String().randomKey)
        
        let clientMeta = Session.ClientMeta(name: "Web3 Boiler",
                                            description: "Web3 Boiler description",
                                            icons: [],
                                            url: clientURL)
        
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)
        
        guard let wcUrl else { return completion(.failure(.connectionError)) }
        
        do {
            try client?.connect(to: wcUrl)
            completion(.success(wcUrl.absoluteString))
        } catch let error {
            print("Main connect error \(error.localizedDescription)")
            completion(.failure(.connectionError))
        }
    }
    
    public func logout() throws {
        guard let session else {
            throw WalletConnectError.sessionMissed
        }
        
        try client?.disconnect(from: session)
    }
    
    public func reconnectIfNeeded() {
        if let oldSessionObject = userDefaults.sessionKey,
           let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client?.reconnect(to: session)
        }
    }
    
    public func getCurrentAddress() -> String? {
        return session?.walletInfo?.accounts.first
    }
    
    public func signTransaction(_ transaction: EthereumTransaction, completion: @escaping WalletConnectionImpl.WCResult) {
        let clientTransaction: Client.Transaction = .init(from: transaction.from!.value,
                                                          to: transaction.to.value,
                                                          data: "",
                                                          gas: nil,
                                                          gasPrice: nil,
                                                          value: transaction.value?.web3.hexString,
                                                          nonce: nil,
                                                          type: nil,
                                                          accessList: nil,
                                                          chainId: nil,
                                                          maxPriorityFeePerGas: nil,
                                                          maxFeePerGas: nil)
        completion(.openWallet)
        sendTransaction(clientTransaction) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func sendTransactionWithData(_ transaction: EthereumTransaction, completion: @escaping WalletConnectionImpl.WCResult) {
        let clientTransaction: Client.Transaction = .init(from: transaction.from!.value,
                                                          to: transaction.to.value,
                                                          data: (transaction.data?.web3.hexString)!,
                                                          gas: nil,
                                                          gasPrice: nil,
                                                          value: nil,
                                                          nonce: nil,
                                                          type: nil,
                                                          accessList: nil,
                                                          chainId: nil,
                                                          maxPriorityFeePerGas: nil,
                                                          maxFeePerGas: nil)
        completion(.openWallet)
        sendTransaction(clientTransaction) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func sendTransaction(_ transaction: Client.Transaction, completion: @escaping (Result<String, WalletConnectError>) -> Void) {
        guard let url = session?.url else {
            completion(.failure(.connectionError))
            return
        }
        do {
            try client?.eth_sendTransaction(url: url, transaction: transaction, completion: { response in
                print("Main sendTransaction response error \(String(describing: response.error)))")
                print("Main sendTransaction response result \(String(describing: try? response.result(as: String.self)))")
                let value = try? response.result(as: String.self)
                
                if let value = value, response.error == nil {
                    completion(.success(value))
                } else {
                    completion(.failure(.transactionFailed(response.error?.localizedDescription ?? "Send Transaction Failed")))
                }
            })
        } catch let error {
            print("Main sendTransaction error \(error)")
            completion(.failure(.transactionFailed(error.localizedDescription)))
        }
    }
}

extension WalletConnectionImpl: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate?.failedToConnect()
    }
    
    func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
    }
    
    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        userDefaults.sessionKey = sessionData
        delegate?.didConnect()
    }
    
    func client(_ client: Client, didDisconnect session: Session) {
        userDefaults.sessionKey = nil
        delegate?.didDisconnect()
    }
    
    func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}
