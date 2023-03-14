import UIKit
import NeedleFoundation

private typealias Module = Debugging

final class DebuggingComponent: Component<DebuggingDependency>, Module.Configurator {
    func configure() -> UIViewController { configure(nil) }
    func configure(_ configuration: Debugging.Configuration?) -> UIViewController {
        let viewCtrl = Module.ViewController()
        configureViewCtrl(viewCtrl, configuration: configuration)
        return viewCtrl
    }
    
    private func configureViewCtrl(_ viewCtrl: Module.ViewController,
                                   configuration: Module.Configuration?) {
        let router = Module.Router(mainRouter: dependency.mainRouter)
        router.viewCtrl = viewCtrl
        
        let presenter = Module.Presenter()
        presenter.view = viewCtrl
        presenter.router = router
        
        let interactor = Module.Interactor(web3RepoFactory: dependency.web3RepoFactory)
        interactor.output = presenter
        
        presenter.interactor = interactor
        viewCtrl.output = presenter
        
        let viewManager: Module.ViewManager = .init()
        viewCtrl.viewManager = viewManager
        viewManager.output = viewCtrl
        
        presenter.moduleOutput = configuration?(presenter)
    }
}
