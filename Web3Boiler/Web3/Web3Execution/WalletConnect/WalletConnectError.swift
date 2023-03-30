import Foundation

public enum WalletConnectResult<T> {
    case success(_ response: T)
    case failure(_ error: WalletConnectError)
    case openWallet
}

public enum WalletConnectError: Error {
    case connectionError
    case failedToGetCurrentAddress
    case transactionFailed(_ message: String)
    case transactionResponseError
    case sessionMissed
}
