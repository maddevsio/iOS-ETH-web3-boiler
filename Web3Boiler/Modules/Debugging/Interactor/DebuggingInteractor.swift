private typealias Module = Debugging

extension Module {
    final class Interactor: InteractorInput {
        enum Constants {
            static let contractUSDC = "0x07865c6E87B9F70255377e024ace6630C1Eaa37F" // Contacrt address goerli usdc
            static let network: Web3ClientConfig = .goerli
        }
        
        weak var output: InteractorOutput!
        
        private let web3RepoFactory: Web3RepoFactory
        private var web3Repo: Web3ClientWriteRepositoryProtocol?
        
        init(web3RepoFactory: Web3RepoFactory) {
            self.web3RepoFactory = web3RepoFactory
        }
        
        func connectToWallet() {
            web3Repo = nil
            web3Repo = web3RepoFactory.build(.walletConnect)
            let metamask = Web3RepoType.walletConnect.wallets.first(where: { $0 == .metamask })?.link ?? ""
            web3Repo?.connect(WalletModel(walletLink: metamask, appStoreUrl: ""), web3Config: Constants.network, completion: { result in
                print("connectToWallet result \(result)")
            })
        }
        
        func web3AccountConnect() {
            web3Repo = nil
            web3Repo = web3RepoFactory.build(.personalAccount)
            web3Repo?.login(.GOOGLE, web3Config: Constants.network) { result in
                print("web3AccountConnect result \(result)")
            }
        }
        
        func logout() {
            Task {
                do {
                    let result = try await web3Repo?.logout()
                    print("logout success \(String(describing: result))")
                } catch let error {
                    print("logout failure \(error)")
                }
            }
        }
        
        public func getGasPrice() {
            Task {
                do {
                    let gasPrice = try await web3Repo?.getGasPrise()
                    print("getGasPrice success \(TorusWeb3Utils.toEther(wei: gasPrice ?? 0))")
                } catch let error {
                    print("getGasPrice failure \(error)")
                }
            }
        }
        
        public func getBalance() {
            Task {
                do {
                    let balance = try await web3Repo?.getBalanceCurrentClient()
                    print("getBalance success \(TorusWeb3Utils.toEther(wei: balance ?? 0))")
                } catch let error {
                    print("getBalance failure \(error)")
                }
            }
        }
        
        public func signTransfer() {
            // Fill address to
            Task {
                do {
                    let result = try await web3Repo?.transfer(to: "",
                                                              value: TorusWeb3Utils.toWei(ether: 0.1))
                    print("signTransfer success \(String(describing: result))")
                } catch let error {
                    print("signTransfer failure \(error)")
                }
            }
        }
        
        func signContractTransfer() {
            // Fill address to
            Task {
                do {
                    let result = try await web3Repo?.transferWithContract(to: "",
                                                                          contract: Constants.contractUSDC,
                                                                          value: TorusWeb3Utils.toStable(amount: 10))
                    print("signContractTransfer success \(String(describing: result))")
                } catch let error {
                    print("signContractTransfer failure \(error)")
                }
            }
        }
        
        func approveTransaction() {
            // Fill address to
            Task {
                do {
                    let result = try await web3Repo?.approve(to: "",
                                                             contract: Constants.contractUSDC,
                                                             value: TorusWeb3Utils.toStable(amount: 100))
                    print("approveTransaction success \(String(describing: result))")
                } catch let error {
                    print("approveTransaction failure \(error)")
                }
            }
        }
        
        func allowanceTransaction() {
            // Fill address owner (from address), sender (to address)
            Task {
                do {
                    let balance = try await web3Repo?.allowance(owner: "",
                                                                sender: nil,
                                                                contract: Constants.contractUSDC)
                    print("allowanceTransaction success \(TorusWeb3Utils.fromStable(amount: balance ?? 0))")
                } catch let error {
                    print("allowanceTransaction failure \(error)")
                }
            }
        }
        
        func transferFromTransaction() {
            // Fill address sender (to address)
            // Fill address recipient (any address)
            Task {
                do {
                    let result = try await web3Repo?.transferFrom(sender: "",
                                                                  recipient: "",
                                                                  contract: Constants.contractUSDC,
                                                                  value: TorusWeb3Utils.toStable(amount: 10))
                    print("transferFromTransaction success \(String(describing: result))")
                } catch let error {
                    print("transferFromTransaction failure \(error)")
                }
            }
        }
    }
}


