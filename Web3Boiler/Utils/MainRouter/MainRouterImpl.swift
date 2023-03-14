import Foundation
import UIKit

class MainRouterImpl: MainRouter {
    
    private let window: WindowProtocol?
    private let application: UIApplication!
    private var rootComponent: RootComponent?
    
    init(window: WindowProtocol?,
         application: UIApplication,
         rootComponent: RootComponent?) {
        self.window = window
        self.application = application
        self.rootComponent = rootComponent
    }
    
    // MARK: - In app main screens routing
    
    func routeToDebugging() {
        guard let debuggingController = rootComponent?.debuggingViewController.configure() else { return }
        window?.switchRootViewCtrl(BaseNavigationController(rootViewController: debuggingController), animated: true)
    }
    
    // MARK: - UIApplication routing
    func canOpenURL(_ url: URL) -> Bool {
        return application.canOpenURL(url)
    }
    
    func open(_ url: URL) {
        DispatchQueue.main.async {
            self.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func open(_ url: URL, completionHandler completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async {
            self.open(url, options: [:], completionHandler: completion)
        }
    }
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any]) {
        DispatchQueue.main.async {
            self.open(url, options: options, completionHandler: nil)
        }
    }
    
    // Options are specified in the section below for openURL options. An empty options dictionary will result in the same
    // behavior as the older openURL call, aside from the fact that this is asynchronous and calls the completion handler rather
    // than returning a result.
    // The completion handler is called on the main queue.
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        return application.open(url, options: options, completionHandler: completion)
    }

    @available(iOS 15.0, *)
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:]) async -> Bool {
        return await application.open(url, options: options)
    }
}
