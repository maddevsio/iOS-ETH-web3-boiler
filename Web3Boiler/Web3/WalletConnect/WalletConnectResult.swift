import Foundation

public enum WalletConnectResult<T> {
    case success(_ response: T)
    case failure(_ error: WalletConnectError)
    case openWallet
}
