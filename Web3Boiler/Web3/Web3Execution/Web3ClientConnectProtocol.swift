import Web3Auth

protocol Web3ClientConnectProtocol {
    func connect(_ wallet: WalletModel, web3Config: Web3ClientConfig, completion: @escaping (Result<Void>) -> Void) // Connect with existing wallet
    func login(_ provider: Web3AuthProvider, web3Config: Web3ClientConfig, completion: @escaping (Result<Void>) -> Void) // Connect with provider via social accounts
    func logout() async throws -> Bool
}

extension Web3ClientConnectProtocol {
    func connect(_ wallet: WalletModel, web3Config: Web3ClientConfig, completion: @escaping (Result<Void>) -> Void) {}
    func login(_ provider: Web3AuthProvider, web3Config: Web3ClientConfig, completion: @escaping (Result<Void>) -> Void) {}
}
