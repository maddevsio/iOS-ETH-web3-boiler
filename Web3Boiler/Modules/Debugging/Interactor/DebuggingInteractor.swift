private typealias Module = Debugging

extension Module {
    final class Interactor: InteractorInput {
        weak var output: InteractorOutput!

        private let web3RepoFactory: Web3RepoFactory
        private var web3Repo: Web3ClientRepository?
        
        init(web3RepoFactory: Web3RepoFactory) {
            self.web3RepoFactory = web3RepoFactory
        }
        
        public func connectToWallet() {
            web3Repo = nil
            web3Repo = web3RepoFactory.build(.walletConnect)
            let metamask = Web3RepoType.walletConnect.wallets.first(where: { $0 == .metamask })?.link ?? ""
            web3Repo?.connect(WalletModel(walletLink: metamask, appStoreUrl: ""), web3Config: .goerli, completion: { result in
                switch result {
                case .success(let address):
                    print("connectToWallet succsess \(address ?? "nil")")
                case .failure(let error):
                    print("connectToWallet failure \(error)")
                }
            })
        }
        
        func web3AccountConnect() {
            web3Repo = nil
            web3Repo = web3RepoFactory.build(.personalAccount)
            web3Repo?.login(.GOOGLE, web3Config: .goerli, completion: { result in
                switch result {
                case .success(let address):
                    print("login web3Auth succsess \(address ?? "nil")")
                case .failure(let error):
                    print("login web3Auth failure \(error)")
                }
            })
        }
        
        public func getGasPrice() {
            web3Repo?.getGasPrise(completion: { result in
                switch result {
                case .success(let gasPrice):
                    print("getGasPrice succsess \(TorusWeb3Utils.toEther(Gwie: gasPrice ?? 0)) Gwei")
                case .failure(let error):
                    print("getGasPrice failure \(error)")
                }
            })
        }
        
        public func getBalance() {
            web3Repo?.getBalanceCurrentClient(completion: { result in
                switch result {
                case .success(let balance):
                    print("getBalance succsess \(TorusWeb3Utils.toEther(wei: balance ?? 0))")
                case .failure(let error):
                    print("getBalance failure \(error)")
                }
            })
        }
        
        public func signTransfer() {
            // Fill address to
            web3Repo?.transfer(to: "",
                               value: TorusWeb3Utils.toWei(ether: 0.01),
                               completion: { result in
                switch result {
                case .success(let hash):
                    print("signTransfer succsess \(String(describing: hash))")
                case .failure(let error):
                    print("signTransfer failure \(error)")
                }
            })
        }
        
        public func signContractTransfer() {
            // Fill address to
            // Contacrt address goerli usdc
            web3Repo?.transferWithContract(to: "",
                                           contract: "0x07865c6E87B9F70255377e024ace6630C1Eaa37F",
                                           value: TorusWeb3Utils.toStable(amount: 10),
                                           completion: { result in
                switch result {
                case .success(let hash):
                    print("signContractTransfer succsess \(String(describing: hash))")
                case .failure(let error):
                    print("signContractTransfer failure \(error)")
                }
            })
        }
        
        public func approveTransaction() {
            // Fill address to
            // Contacrt address goerli usdc
            web3Repo?.approve(to: "",
                              contract: "0x07865c6E87B9F70255377e024ace6630C1Eaa37F",
                              value: TorusWeb3Utils.toStable(amount: 100),
                              completion: { result in
                switch result {
                case .success(let hash):
                    print("approveTransaction succsess \(String(describing: hash))")
                case .failure(let error):
                    print("approveTransaction failure \(error)")
                }
            })
        }
        
        public func allowanceTransaction() {
            // Fill address owner (from address), sender (to address)
            // If sender nil, sender = signed address
            // Contacrt address goerli usdc
            web3Repo?.allowance(owner: "",
                                sender: nil,
                                contract: "0x07865c6E87B9F70255377e024ace6630C1Eaa37F",
                                completion: { result in
                switch result {
                case .success(let balance):
                    print("allowanceTransaction succsess \(TorusWeb3Utils.fromStable(amount: balance ?? 0))")
                case .failure(let error):
                    print("allowanceTransaction failure \(error)")
                }
            })
        }
        
        public func transferFromTransaction() {
            // Fill address sender (to address)
            // Fill address recipient (any address)
            // Contacrt address goerli usdc
            web3Repo?.transferFrom(sender: "",
                                   recipient: "",
                                   contract: "0x07865c6E87B9F70255377e024ace6630C1Eaa37F",
                                   value: TorusWeb3Utils.toStable(amount: 10),
                                   completion: { result in
                switch result {
                case .success(let hash):
                    print("transferFromTransaction succsess \(String(describing: hash))")
                case .failure(let error):
                    print("transferFromTransaction failure \(error)")
                }
            })
        }
    }
}


