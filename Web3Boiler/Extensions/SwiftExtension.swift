import Foundation

public func print(_ object: Any) {
    #if Dev
    Swift.print("🧨🧨🧨 \(Date()): \(object)")
    #endif
}
