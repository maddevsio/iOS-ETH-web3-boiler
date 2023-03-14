import Foundation

protocol UserDefaultsStorage: AnyObject {
    var secureStorageKey: String? { get set }
    var sessionKey: Data? { get set }
}

