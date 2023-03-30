import UIKit

public protocol Configs {
    // Info.plist
    func getKey(_ key: ConfigsKey) -> String?
    func getUrl(_ key: ConfigsUrl) -> URL?
}

public enum AppConfigurationState {
    case Debug, TestFlight, AppStore
}

public enum ConfigsUrl: String {
    case projURL = "PROJ_URL"
    case bridgeTestURL = "BRIDGE_TEST_URL"
    case goerliURL = "GOERLI_URL"
    case ethereumURL = "ETHEREUM_URL"
    case polygonURL = "POLYGON_URL"
    case sepoliaURL = "SEPOLIA_URL"
}

public enum ConfigsKey: String {
    case wcID = "WC_PROJECT_ID"
    case web3AuthID = "WEB3_AUTH_ID"
    case web3AuthNetwork = "WEB3_AUTH_NETWORK"
    case alchemyKey = "ALCHEMY_KEY"
}
