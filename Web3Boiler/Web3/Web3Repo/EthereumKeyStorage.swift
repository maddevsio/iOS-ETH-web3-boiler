//
//  EthereumKeyStorage.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 8/2/23.
//

import Foundation
import web3

protocol EthKeyStorage: EthereumKeyStorageProtocol {
    func getPrivateKey() -> Data?
}

class EthereumKeyStorage: EthKeyStorage {
    private let secureStorage: SecureStorage
    
    init(_ secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }
    
    public func storePrivateKey(key: Data) throws {
        secureStorage.key = key
    }
    
    public func loadPrivateKey() throws -> Data {
        guard let pKey = secureStorage.key else {
            throw Web3ClientError.FailedToGetKey
        }
        
        return pKey
    }
    
    public func getPrivateKey() -> Data? {
        do {
            return try loadPrivateKey()
        } catch _ {
            return nil
        }
    }
}
