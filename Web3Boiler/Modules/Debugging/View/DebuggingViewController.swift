import UIKit
import SnapKit

private typealias Module = Debugging

extension Module {
    final class ViewController: BaseViewController {

        var output: ViewOutput?
        var viewManager: ViewManaging!
        
        //MARK: - Views
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupConstraints()
            setupUI()
            output?.viewDidLoad()
        }
        
        fileprivate func setupUI() {
            view.backgroundColor = UIColor.white
            navigationItem.title = Localization.Debugging.title
        }
        
        fileprivate func setupConstraints() {
            view.addSubview(viewManager.customizedTable)
            
            viewManager.customizedTable.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}

extension Module.ViewController: Module.ViewInput {
    func display(viewModel: Debugging.ViewModel) {
        viewManager.reloadViewData(viewModel)
    }
}

extension Module.ViewController: Module.ViewManager.ViewManagerOutput {
    func didSelectItem(_ item: Debugging.DebuggingActions) {
        output?.itemSelected(item)
    }
}
