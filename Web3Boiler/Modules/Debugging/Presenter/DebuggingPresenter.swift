private typealias Module = Debugging

extension Module {
    final class Presenter: ViewOutput {

        weak var view: ViewInput!
        weak var moduleOutput: ModuleOutput?
        
        var interactor: InteractorInput!
        var router: RouterInput!
        
        private var configData: ConfigData?
        
        func viewDidLoad() {
            view.display(viewModel: .init(data: Debugging.DebuggingActions.allCases))
        }
        
        func itemSelected(_ item: Debugging.DebuggingActions) {
            switch item {
            case .walletConnect:
                interactor.connectToWallet()
            case .web3Account:
                interactor.web3AccountConnect()
            case .getGasPrice:
                interactor.getGasPrice()
            case .getBalanceCurrentAddress:
                interactor.getBalance()
            case .signTransaction:
                interactor.signTransfer()
            case .signContractTransaction:
                interactor.signContractTransfer()
            case .approveTransaction:
                interactor.approveTransaction()
            case .allowanceTransaction:
                interactor.allowanceTransaction()
            case .transferFromTransaction:
                interactor.transferFromTransaction()
            }
        }
    }
}

extension Module.Presenter: Module.ModuleInput {
    func configure(_ data: Debugging.ConfigData) {
        self.configData = data
    }
}

extension Module.Presenter: Module.InteractorOutput {}
