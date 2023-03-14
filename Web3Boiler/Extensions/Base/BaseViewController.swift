import UIKit

open class BaseViewController: UIViewController, BaseViewInput {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        baseSetupUI()
        
        print("viewDidLoad | \(String.init(describing: self)) |")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("Deinit | \(String.init(describing: self)) |")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func baseSetupUI() {
        
    }
    
    // MARK: - BaseViewInput
    
    public func showError(title: String, error: String) {
        showAlert(title: title, message: error, actionTitle: "", action: nil, cancellable: true)
    }
    
    public func showAlert(title: String,
                          message: String,
                          actionTitle: String,
                          action callback: (() -> Void)?,
                          cancellable: Bool) {
        let alert: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if !actionTitle.isEmpty {
            let action = UIAlertAction.init(title: actionTitle, style: .default, handler: { _ in callback?() })
            alert.addAction(action)
        }
        if cancellable {
            let cancel = UIAlertAction.init(title: Localization.Common.close, style: .default, handler: nil)
            alert.addAction(cancel)
        }
        present(alert, animated: true, completion: nil)
    }
}
