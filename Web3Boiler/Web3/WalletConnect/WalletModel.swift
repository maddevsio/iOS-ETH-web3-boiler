//
//  WalletModel.swift
//  Web3Boiler
//
//  Created by Pavel Pushkarev on 10/1/23.
//

import Foundation

class WalletModel {
    let walletLink: String
    var walletUrl: URL? {
        return URL(string: walletLink)
    }
    
    let appStoreUrl: String
    
    init(walletLink: String, appStoreUrl: String) {
        self.walletLink = walletLink
        self.appStoreUrl = appStoreUrl
    }
    
    /// Based on the wallet connect url, returns either universal link (preferred) or a deeplink to establish
    /// WalletConnect connection. Preserves path in the universal link in the entry
    ///
    /// see: https://docs.walletconnect.com/mobile-linking#for-ios
    func connectLink(connectionPart: String) -> URL? {
        guard let walletUrl else { return nil }
        var components = URLComponents(url: walletUrl, resolvingAgainstBaseURL: false)
        let encodedUri = connectionPart.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        components?.percentEncodedQuery = "uri=\(encodedUri)"

        if let url = components?.url, url.lastPathComponent != "wc" {
            components?.path = url.appendingPathComponent("wc").path
        }
        
        return components?.url
    }
}
