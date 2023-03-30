import UIKit
import NeedleFoundation
import web3

class RootComponent: BootstrapComponent {
    // MARK: - Utilities
    var userStorage: UserDefaultsStorage {
        return shared { UserStorageImpl() }
    }
    var configs: Configs {
        return shared { ConfigsImpl() }
    }
    var secureStorage: SecureStorage {
        return shared { SecureStorageImpl(userStorage: userStorage) }
    }
    var appWindow: UIWindow? {
        return sceneDelegate?.window
    }
    var application: UIApplication {
        return UIApplication.shared
    }
    var mainRouter: MainRouter {
        return MainRouterImpl(window: appWindow,
                              application: application,
                              rootComponent: self)
    }
    
    // MARK: - Core App components
    
    private var appDelegate: AppDelegate? {
        return application.delegate as? AppDelegate
    }
    
    private var sceneDelegate: SceneDelegate? {
        return application.connectedScenes.first?.delegate as? SceneDelegate
    }
    var walletConnection: WalletConnection {
        return shared { WalletConnectionImpl(userDefaults: userStorage, configs: configs) }
    }
    var web3AuthClient: Web3AuthClient {
        return shared {
            return Web3AuthClientImpl(config: configs)
        }
    }
    var web3Transaction: Web3ClientFunctions {
        return Web3ClientFunctionsImpl()
    }
    var ethStorage: EthKeyStorage {
        return EthereumKeyStorage(secureStorage)
    }
    var web3Repository: Web3ClientWriteRepositoryProtocol {
        return shared { Web3RepositoryImpl(configs: configs,
                                           web3Auth: web3AuthClient,
                                           web3ClientTransaction: web3Transaction,
                                           storage: ethStorage) }
    }
    var walletConnectionRepo: Web3ClientWriteRepositoryProtocol {
        return shared { return WalletConnectionRepositoryImpl(mainRouter: mainRouter,
                                                              configs: configs,
                                                              walletConnect: walletConnection,
                                                              web3ClientTransaction: web3Transaction) }
    }
    var web3RepoFactory: Web3RepoFactory {
        return Web3RepoFactoryImpl(walletConnect: walletConnectionRepo,
                                   web3Client: web3Repository)
    }
    
    // MARK: DI components
    // Define dependencies by using .Configurator and use same when passing modules protocol in arguments
    
    var debuggingViewController: Debugging.Configurator {
        return DebuggingComponent(parent: self)
    }
}
