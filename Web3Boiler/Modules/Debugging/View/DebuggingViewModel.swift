private typealias Module = Debugging

extension Module {
    public struct ViewModel {
        let data: [DebuggingActions]
    }
    
    public enum DebuggingActions: Int, CaseIterable {
        case walletConnect,
             web3Account,
             logout,
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
                return "Wallet connect MetaMask"
            case .web3Account:
                return "Web3Auth google account"
            case .logout:
                return "Logout"
            case .getGasPrice:
                return "Get gas price"
            case .getBalanceCurrentAddress:
                return "Get balance for current address"
            case .signTransaction:
                return "Transfer Goerli ETH"
            case .signContractTransaction:
                return "Transfer Goerli ETH USDC"
            case .approveTransaction:
                return "Approve Goerli ETH USDC"
            case .allowanceTransaction:
                return "Get approved Goerli ETH USDC"
            case .transferFromTransaction:
                return "Transfer approved Goerli ETH USDC"
            }
        }
    }
}
