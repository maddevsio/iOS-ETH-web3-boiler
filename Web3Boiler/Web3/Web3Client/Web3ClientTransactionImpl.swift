//
//  ArgentClient.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 12/1/23.
//

import Foundation
import web3
import BigInt

protocol Web3ClientTransaction {
    func transfer(from: String, to: String, value: BigUInt, gasPrice: BigUInt?, gasLimit: BigUInt?) throws -> EthereumTransaction
    func contractTransfer(from: String, to: String, contract: String, value: BigUInt, gasPrice: BigUInt?, gasLimit: BigUInt?) throws -> EthereumTransaction
    func approveTransaction(from: String, to: String, contract: String, value: BigUInt, gasPrice: BigUInt?, gasLimit: BigUInt?) throws -> EthereumTransaction
    func allowanceTransaction(from: String, owner: String, sender: String, contract: String) throws -> EthereumTransaction
    func transferFromTransaction(from: String, sender: String, recipient: String, contract: String, value: BigUInt, gasPrice: BigUInt?, gasLimit: BigUInt?) throws -> EthereumTransaction
}

struct Web3ClientTransactionImpl: Web3ClientTransaction {
    public func transfer(from: String, to: String, value: BigUInt, gasPrice: BigUInt?, gasLimit: BigUInt?) throws -> EthereumTransaction {
        let function = Transfer(from: EthereumAddress(from), contract: EthereumAddress(to), value: value, gasPrice: gasPrice, gasLimit: gasLimit)
        return try function.transaction(value: value, gasPrice: gasPrice, gasLimit: gasLimit)
    }
    
    public func contractTransfer(from: String, to: String, contract: String, value: BigUInt, gasPrice: BigUInt?, gasLimit: BigUInt?) throws -> EthereumTransaction {
        let function = ContractTransfer(contract: EthereumAddress(contract), from: EthereumAddress(from), to: EthereumAddress(to), value: value, gasPrice: gasPrice, gasLimit: gasLimit)
        return try function.transaction()
    }
    
    public func approveTransaction(from: String, to: String, contract: String, value: BigUInt, gasPrice: BigUInt?, gasLimit: BigUInt?) throws -> EthereumTransaction {
        let function = Approve(contract: EthereumAddress(contract), from: EthereumAddress(from), to: EthereumAddress(to), value: value, gasPrice: gasPrice, gasLimit: gasLimit)
        return try function.transaction()
    }
    
    public func allowanceTransaction(from: String, owner: String, sender: String, contract: String) throws -> EthereumTransaction {
        let function = Allowance(contract: EthereumAddress(contract), from: EthereumAddress(from), owner: EthereumAddress(owner), sender: EthereumAddress(sender))
        return try function.transaction()
    }
    
    public func transferFromTransaction(from: String, sender: String, recipient: String, contract: String, value: BigUInt, gasPrice: BigUInt?, gasLimit: BigUInt?) throws -> EthereumTransaction {
        let function = TransferFrom(contract: EthereumAddress(contract), from: EthereumAddress(from), sender: EthereumAddress(sender), recipient: EthereumAddress(recipient), value: value, gasPrice: gasPrice, gasLimit: gasLimit)
        return try function.transaction()
    }
}
