import UIKit

extension UIWindow: WindowProtocol {
    
    func switchRootViewCtrl(_ viewCtrl: UIViewController) {
        switchRootViewCtrl(viewCtrl, animated: true)
    }
    
    func switchRootViewCtrl(_ viewCtrl: UIViewController,
                            animated: Bool) {
        switchRootViewCtrl(viewCtrl,
                           animated: animated,
                           duration: 0.5,
                           options: .transitionCrossDissolve,
                           completion: nil)
    }
    
    func switchRootViewCtrl(_ viewCtrl: UIViewController,
                            animated: Bool,
                            duration: TimeInterval,
                            options: UIView.AnimationOptions,
                            completion: (() -> Void)?) {
        
        guard animated, rootViewController != nil else {
            let initial = rootViewController == nil
            rootViewController = viewCtrl
            if initial {
                makeKeyAndVisible()
            }
            return
        }
        completion?()
    }
}
