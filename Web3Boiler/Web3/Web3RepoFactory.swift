import Foundation

protocol Web3RepoFactory {
    func build(_ type: Web3RepoType) -> Web3ClientWriteRepositoryProtocol
}

public enum Web3RepoType {
    case walletConnect
    case personalAccount
    
    var wallets: [Wallets] {
        switch self {
        case .walletConnect:
            return Wallets.allCases
        case .personalAccount:
            return []
        }
    }
}

public enum Wallets: CaseIterable {
    case metamask
    
    var link: String {
        switch self {
        case .metamask:
            return "https://metamask.app.link"
        }
    }
}

struct Web3RepoFactoryImpl: Web3RepoFactory {
    private let walletConnect: Web3ClientWriteRepositoryProtocol
    private let web3Client: Web3ClientWriteRepositoryProtocol
    
    init(walletConnect: Web3ClientWriteRepositoryProtocol,
         web3Client: Web3ClientWriteRepositoryProtocol) {
        self.walletConnect = walletConnect
        self.web3Client = web3Client
    }
    
    func build(_ type: Web3RepoType) -> Web3ClientWriteRepositoryProtocol {
        switch type {
        case .walletConnect:
            return walletConnect
        case .personalAccount:
            return web3Client
        }
    }
}
