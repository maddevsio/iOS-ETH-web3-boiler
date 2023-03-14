import Foundation

private typealias Module = Debugging

public extension Module {
    typealias InteractorInput = DebuggingInteractorInput
    typealias InteractorOutput = DebuggingInteractorOutput
}

public protocol DebuggingInteractorInput {
    func connectToWallet()
    func web3AccountConnect()
    func getGasPrice()
    func getBalance()
    func signTransfer()
    func signContractTransfer()
    func approveTransaction()
    func allowanceTransaction()
    func transferFromTransaction()
}

public protocol DebuggingInteractorOutput: AnyObject {
    
}
