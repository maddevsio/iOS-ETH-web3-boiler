import Foundation
import KeychainSwift

class SecureStorageImpl: SecureStorage {
    private enum Keys: String {
        case key
    }
    
    private let keychain: KeychainSwift!
    
    init(userStorage: UserDefaultsStorage) {
        if let key = userStorage.secureStorageKey {
            self.keychain = .init(keyPrefix: key)
        } else { // logic to store new data when app reinstalled
            let key = UUID().uuidString
            userStorage.secureStorageKey = key
            self.keychain = .init(keyPrefix: key)
            self.keychain.clear()
        }
    }
    
    // MARK: - Helper functions
    
    private func saveObjectForKey<T: Encodable>(_ key: Keys, obj: T) {
        guard let data = dataFromDecodable(obj) else { return }
        keychain.set(data, forKey: key.rawValue, withAccess: nil)
    }
    
    private func dataFromDecodable<T: Encodable>(_ obj: T) -> Data? {
        return try? JSONEncoder().encode(obj)
    }
    
    private func parseObjectFromKey<T: Decodable>(_ key: Keys) -> T? {
        guard let data = keychain.getData(key.rawValue)
        else { return nil }
        return parseObjectFromData(data)
    }
    
    private func parseObjectFromData<T: Decodable>(_ data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - get set
    
    var key: Data? {
        set { saveObjectForKey(.key, obj: newValue) }
        get { return parseObjectFromKey(.key) }
    }
    
    func clear() {
        keychain.clear()
    }
}
