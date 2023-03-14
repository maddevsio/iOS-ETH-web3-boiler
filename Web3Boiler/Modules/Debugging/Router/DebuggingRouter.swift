import UIKit

private typealias Module = Debugging

extension Module {
    final class Router: RouterInput {
        weak var viewCtrl: UIViewController?
        private let mainRouter: MainRouter
        
        init(mainRouter: MainRouter) {
            self.mainRouter = mainRouter
        }
    }
}
