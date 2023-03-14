private typealias Module = Debugging

extension Module {
    public struct ViewModel {
        let data: [DebuggingActions]
    }
    
    public enum DebuggingActions: Int, CaseIterable {
        case walletConnect,
             web3Account,
             getGasPrice,
             getBalanceCurrentAddress,
             signTransaction,
             signContractTransaction,
             approveTransaction,
             allowanceTransaction,
             transferFromTransaction
        
        var title: String {
            switch self {
            case .walletConnect:
                return Localization.Debugging.connectWallet
            case .web3Account:
                return Localization.Debugging.web3Account
            case .getGasPrice:
                return Localization.Debugging.gasPrice
            case .getBalanceCurrentAddress:
                return Localization.Debugging.balanceCurrentAddress
            case .signTransaction:
                return Localization.Debugging.transaction
            case .signContractTransaction:
                return Localization.Debugging.contractTransaction
            case .approveTransaction:
                return Localization.Debugging.approve
            case .allowanceTransaction:
                return Localization.Debugging.allowance
            case .transferFromTransaction:
                return Localization.Debugging.transferFrom
            }
        }
    }
}
