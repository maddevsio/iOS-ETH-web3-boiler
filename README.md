# Web3Boiler iOS

## Description
This project is an example of set frameworks implementations that may help you to communicate with the Ethereum blockchain.

## Requirements
- iOS 14.0+
- Xcode 13.0+

## Getting started
- [x] Install Needle DI `brew install needle` [source](https://github.com/uber/needle#install-code-generator) [brew](https://brew.sh/)

## Project structure
- Package Manager is also Apple native [SPM](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)
- Dependency Manager is [Needle](https://github.com/uber/needle)  ~> 0.18.1, which made and used by Uber. It's better that Swinject because gives dependency missing errors on compile time and decreases our app speed by not overloading runtime.
- Schemes handled by config files under `/SupportingFiles/Configurations/` for Dev flavors

### Dependencies
- Secure Data Storage with [KeychainSwift](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain) , but simplify usage with framework [KeychainSwift](https://github.com/evgenyneu/keychain-swift) ~> 20.0.0
- UI mockups we use [SnapKit](https://github.com/SnapKit/SnapKit) ~> 5.6.0 which works on AutoLayout with Constraints. NO Storyboards. Code only.
- [NeedleFoundation](https://github.com/uber/needle.git) ~> 0.19.0
- [WalletConnect V1](https://github.com/WalletConnect/WalletConnectSwift.git) V1 ~> 1.0.0
- [Web3Auth](https://github.com/web3auth/web3auth-swift-sdk.git) ~> 5.0.0
- [Ethereum web3](https://github.com/argentlabs/web3.swift) Ethereum Swift API with support for smart contracts, ENS & ERC20 ~> 1.1.0

### In app utils
- Configs - Info.plist keys wrapper, Environment variables storage.
- MainRouter - Route through main root screens.
- SecureStorage - Wrapper for KeychainSwift. Store sensitive user information.
- UserDefaultsStorage - Store local app state temporary data.
- WindowProtocol - Wrapper for UIWindow. Handles switch current screen or display something over all app.

### Services & accounts
- Create account into the [WalletConnect](https://walletconnect.com/), [Documentation](https://docs.walletconnect.com/1.0/)
- Create account into the [Alchemy](https://www.alchemy.com/)
- Create account into the [Web3Auth](https://web3auth.io/), [Documentation](https://web3auth.io/docs/sdk/ios/initialize). Setup project bundle id into the web3auth admin panel.

### Environmvet variables into the xcconfig file
- WC_PROJECT_ID - WalletConnect project ID
- WEB3_AUTH_ID - Web3Auth project ID
- ALCHEMY_KEY - Alchemy key
- PROJ_URL - Project URL for description

### Features:
- WalletConnect V1 pairing with Metamask
- Web3Auth accounting with gmail
- Get gasPrice
- Get account balance
- Make Transfer with Goerli ETH token
- Make Transfer with Goerli USDC stablecoin via SmartContract
- Make Approve with Goerli USDC stablecoin via SmartContract
- Make Allowance with Goerli USDC stablecoin via SmartContract
- Make Transfer from with Goerli USDC stablecoin via SmartContract

[More info about types of transaction](https://docs.openzeppelin.com/contracts/2.x/api/token/erc20)

### [Nominals](https://www.alchemy.com/gwei-calculator):
- 0.01 goerli eth = 10000000000000000 (wei)
- 1 USDC = 1000000 (Mwei)

### Check transactions:
- [Goerli Etherscan](https://goerli.etherscan.io/), set account address or hash of transaction
- Into the alchemy profile.

### Networks
- Goerli
- Ethereum
- Polygon
- Sepolia

### Build project recomendations
- DebuggingInteractor fill addresses
- Setup personal developer account into the Signing & Capabilities
- Install Metamask on your device and Sign in
- Run project on personal device
- If you using not a goerli network, you should update USDC contract address into the Constants
