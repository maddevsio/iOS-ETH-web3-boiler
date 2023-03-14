import UIKit

open class BaseNavigationController: UINavigationController {
    init() {
        super.init(nibName: nil, bundle: nil)
        baseSetupUI()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        baseSetupUI()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        baseSetupUI()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        baseSetupUI()
    }
    
    private func baseSetupUI() {
        setupUI()
    }
    
    open func setupUI() {}
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return viewControllers.last
    }
}
