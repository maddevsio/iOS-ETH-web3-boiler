//
//  Web3ClientError.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 26/1/23.
//

import Foundation

public enum Web3ClientError: Error {
    case FromAddressNotFound
    case FailedToGetKey
}
