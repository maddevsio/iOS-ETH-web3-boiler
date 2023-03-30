import Foundation

public enum Web3ClientError: Error {
    case FromAddressNotFound
    case FailedToGetKey
    case EnvVariablesNotFound
    case ResultError
}
