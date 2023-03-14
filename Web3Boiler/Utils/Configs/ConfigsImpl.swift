import Foundation
import UIKit

class ConfigsImpl: Configs {
    // MARK: - Configs
    // Data read from Release, Debug files under /SupportingFiles/Configurations/
    // To access them need to copy keys as accessors in Info.plist
    
    func getUrl(_ key: ConfigsUrl) -> URL? {
        let url: String? = try? value(for: key.rawValue)
        guard let replacedUrl = url?.replacingOccurrences(of: "\\", with: "") else { return nil }
        return URL(string: replacedUrl)
    }
    
    func getKey(_ key: ConfigsKey) -> String? {
        return try? value(for: key.rawValue)
    }

    private func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw ConfigError.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw ConfigError.invalidValue
        }
    }
    
    enum ConfigError: Swift.Error {
        case missingKey, invalidValue
    }
}
