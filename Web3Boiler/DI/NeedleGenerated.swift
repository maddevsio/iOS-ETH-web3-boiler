

import Foundation
import NeedleFoundation
import UIKit
import web3

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class DebuggingDependency7532b1dcea59b3b023fbProvider: DebuggingDependency {
    var mainRouter: MainRouter {
        return rootComponent.mainRouter
    }
    var web3RepoFactory: Web3RepoFactory {
        return rootComponent.web3RepoFactory
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->DebuggingComponent
private func factory44a2b2562eaee57175c7b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return DebuggingDependency7532b1dcea59b3b023fbProvider(rootComponent: parent1(component) as! RootComponent)
}

#else
extension RootComponent: Registration {
    public func registerItems() {


    }
}
extension DebuggingComponent: Registration {
    public func registerItems() {
        keyPathToName[\DebuggingDependency.mainRouter] = "mainRouter-MainRouter"
        keyPathToName[\DebuggingDependency.web3RepoFactory] = "web3RepoFactory-Web3RepoFactory"
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

private func register1() {
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->DebuggingComponent", factory44a2b2562eaee57175c7b3a8f24c1d289f2c0f2e)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
