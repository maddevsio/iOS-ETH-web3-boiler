import Foundation
import UIKit

protocol MainRouter {
    // In app main screens routing
    func routeToDebugging()
    
    // UIApplication routing
    func canOpenURL(_ url: URL) -> Bool
    
    func open(_ url: URL)
    func open(_ url: URL, completionHandler completion: ((Bool) -> Void)?)
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any])
    // Options are specified in the section below for openURL options. An empty options dictionary will result in the same
    // behavior as the older openURL call, aside from the fact that this is asynchronous and calls the completion handler rather
    // than returning a result.
    // The completion handler is called on the main queue.
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)

    @available(iOS 15.0, *) // works from iOS 13 (but needs xcode 13.4), otherwise requires iOS 15
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any]) async -> Bool
}
