import Foundation
import NeedleFoundation
import UIKit

public extension Debugging {
    typealias Configurator = DebuggingProtocol
}

public protocol DebuggingProtocol: BaseConfigureProtocol {
    func configure(_ configuration: Debugging.Configuration?) -> UIViewController
}

protocol DebuggingDependency: Dependency {
    var mainRouter: MainRouter { get }
    var web3RepoFactory: Web3RepoFactory { get }
}
