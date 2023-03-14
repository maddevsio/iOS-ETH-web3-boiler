//
//  Web3ClientConfig.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 24/1/23.
//

import Foundation

enum Web3ClientConfig {
    case goerli
    case ethereum
    case polygon
    
    var name: String {
        switch self {
        case .goerli:
            return "Goerli Test Network"
        case .ethereum:
            return "Ethereum Mainnet"
        case .polygon:
            return "Polygon Mainnet"
        }
    }
    
    var chainId: Int {
        switch self {
        case .goerli:
            return 5
        case .ethereum:
            return 1
        case .polygon:
            return 137
        }
    }
    
    var baseUrl: URL? {
        switch self {
        case .goerli:
            return ConfigsImpl().getUrl(.goerliURL)
        case .ethereum:
            return nil
        case .polygon:
            return nil
        }
    }
}
