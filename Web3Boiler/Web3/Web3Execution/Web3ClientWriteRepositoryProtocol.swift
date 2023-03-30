import Foundation
import Web3Auth
import BigInt
import web3

protocol Web3ClientWriteRepositoryProtocol: Web3ClientReadRepositoryProtocol, Web3ClientConnectProtocol {
    func transfer(to: String, value: BigUInt) async throws -> String?
    func transferWithContract(to: String, contract: String, value: BigUInt) async throws -> String?
    func approve(to: String, contract: String, value: BigUInt) async throws -> String?
    func transferFrom(sender: String, recipient: String, contract: String, value: BigUInt) async throws -> String?
}
