import Foundation

enum Web3ClientConfig {
    case goerli
    case ethereum
    case polygon
    case sepolia
    
    var name: String {
        switch self {
        case .goerli:
            return "Goerli Test Network"
        case .ethereum:
            return "Ethereum Mainnet"
        case .polygon:
            return "Polygon Mainnet"
        case .sepolia:
            return "Sepolia"
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
        case .sepolia:
            return 11155111
        }
    }
    
    var baseUrl: URL? {
        switch self {
        case .goerli:
            return ConfigsImpl().getUrl(.goerliURL)
        case .ethereum:
            return ConfigsImpl().getUrl(.ethereumURL)
        case .polygon:
            return ConfigsImpl().getUrl(.polygonURL)
        case .sepolia:
            return ConfigsImpl().getUrl(.sepoliaURL)
        }
    }
}
