# Web3Boiler iOS

## Requirements
- iOS 14.0+
- Xcode 13.0+

## Getting started
- [x] Install Needle DI `brew install needle`  [source](https://github.com/uber/needle#install-code-generator) [brew](https://brew.sh/)

## Project structure
- Package Manager is also Apple native [SPM](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)
- Dependency Manager is [Needle](https://github.com/uber/needle)  ~> 0.18.1, which made and used by Uber. It's better that Swinject because gives dependency missing errors on compile time and decreases our app speed by not overloading runtime.
- Schemes handled by config files under `/SupportingFiles/Configurations/` for Dev flavors

### Dependencies
- Secure Data Storage with [KeychainSwift](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain) , but simplify usage with framework [KeychainSwift](https://github.com/evgenyneu/keychain-swift) ~> 20.0.0
- UI mockups we use [SnapKit](https://github.com/SnapKit/SnapKit) ~> 5.6.0 which works on AutoLayout with Constraints. NO Storyboards. Code only.
- [NeedleFoundation](https://github.com/uber/needle.git) NeedleFoundation ~> 0.19.0

### In app utils
- Configs - Info.plist keys wrapper, Environment variables storage.
- MainRouter - Route through main root screens (Splash/Login/Main/CreateProfile)
- SecureStorage - wrapper for KeychainSwift. Store sensitive user information
- UserDefaultsStorage - store local app state temporary data.
- WindowProtocol - Wrapper for UIWindow. Handles switch current screen or display something over all app

### Services & accounts
- https://walletconnect.com/
- https://www.alchemy.com/
- https://web3auth.io/

### Environmvet variables into the xcconfig file
- WC_PROJECT_ID - WalletConnect project ID
- WEB3_AUTH_ID - Web3Auth project ID
- ALCHEMY_KEY - Alchemy key
- PROJ_URL - Project URL for description
