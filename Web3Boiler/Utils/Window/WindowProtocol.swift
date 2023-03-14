import UIKit

protocol WindowProtocol {
    func switchRootViewCtrl(_ viewCtrl: UIViewController,
                            animated: Bool,
                            duration: TimeInterval,
                            options: UIView.AnimationOptions,
                            completion: (() -> Void)?
    )
    
    func switchRootViewCtrl(_ viewCtrl: UIViewController)
    
    func switchRootViewCtrl(_ viewCtrl: UIViewController,
                            animated: Bool
    )
    
    var rootViewController: UIViewController? { get }
}
