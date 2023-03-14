import Foundation

protocol SecureStorage: AnyObject {
    func clear()
    var key: Data? { get set }
}
