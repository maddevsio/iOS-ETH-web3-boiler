import Foundation

public enum WalletConnectError: Error {
    case connectionError
    case failedToGetCurrentAddress
    case transactionFailed(_ message: String)
    case transactionResponseError
}
