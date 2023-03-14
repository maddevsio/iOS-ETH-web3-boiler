import Foundation

class UserStorageImpl: UserDefaultsStorage {
    private enum Keys: String {
        case secureStorageKey
        case sessionKey
    }
    
    private let storage = UserDefaults.standard
    
    // MARK: - fields
    
    var secureStorageKey: String? {
        get { return storage.string(forKey: Keys.secureStorageKey.rawValue) }
        set { storage.set(newValue, forKey: Keys.secureStorageKey.rawValue) }
    }
    
    var sessionKey: Data? {
        get { return storage.data(forKey: Keys.sessionKey.rawValue) }
        set { storage.set(newValue, forKey: Keys.sessionKey.rawValue) }
    }
}
