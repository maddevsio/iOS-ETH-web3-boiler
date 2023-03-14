import Foundation
import UIKit

extension String {
    var randomKey: String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        guard status == errSecSuccess else { return String() }
        return Data(bytes: bytes, count: 32).toHexString()
    }
}
