//
//  Web3AuthClient.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 24/1/23.
//

import Foundation
import Web3Auth

protocol Web3AuthClient {
    func login(_ provider: Web3AuthProvider) async throws -> Web3AuthState?
    func logout() async -> Bool
}

class Web3AuthClientImpl: Web3AuthClient {
    private let config: Configs
    private(set) var web3auth: Web3Auth!
    
    init(config: Configs) {
        self.config = config
        setup()
    }
    
    fileprivate func setup() {
        guard let id = config.getKey(.web3AuthID),
              let networkKey = config.getKey(.web3AuthNetwork),
              let network = Network.init(rawValue: networkKey) else { return }
        
        Task {
            web3auth = await Web3Auth(.init(clientId: id,
                                            network: network,
                                            redirectUrl: nil,
                                            whiteLabel: .init(name: "Web3Boiler")))
        }
        
    }
    
    public func login(_ provider: Web3AuthProvider) async throws -> Web3AuthState? {
        return try await web3auth?.login(.init(loginProvider: provider))
    }
    
    public func logout() async -> Bool {
        do {
            try await web3auth?.logout()
            return true
        } catch {
            return false
        }
    }
}
