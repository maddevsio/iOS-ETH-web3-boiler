import Foundation

protocol WalletConnectionDelegate: AnyObject {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}
