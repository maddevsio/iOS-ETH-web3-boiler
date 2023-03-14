import UIKit

private typealias Module = Debugging

protocol DebuggingViewManaging {
    var customizedTable: UITableView { get }
    var output: DebuggingViewManagingOutput? { get set }
    func reloadViewData(_ data: Debugging.ViewModel)
}

extension Module {
    typealias ViewManaging = DebuggingViewManaging

    class ViewManager: NSObject, ViewManaging {
        public weak var output: ViewManager.ViewManagerOutput?
            
        private(set) var data: [Debugging.DebuggingActions] = []
    
        private(set) lazy var customizedTable: UITableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            tableView.backgroundColor = UIColor.white
            tableView.separatorStyle = .singleLine
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(DebuggingViewManagerCell.self)
            return tableView
        }()
        
        func reloadViewData(_ data: Debugging.ViewModel) {
            self.data = data.data
            customizedTable.reloadData()
        }
    }
}

extension Module.ViewManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellForRow(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       return nil
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}


extension Module.ViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = getSectionType(indexPath.section) else { return }
        output?.didSelectItem(item)
    }
}

extension Module.ViewManager {
    fileprivate func getSectionType(_ section: Int) -> Module.DebuggingActions? {
        return Module.DebuggingActions(rawValue: section)
    }
    
    fileprivate func numberOfSections() -> Int {
        return data.count
    }
    
    fileprivate func numberOfRows(_ section: Int) -> Int {
        return 1
    }
    
    fileprivate func getItemAtIndexPath(_ indexPath: IndexPath) -> Module.DebuggingActions? {
        guard let section = getSectionType(indexPath.section) else { return nil }
        return section
    }
    
    fileprivate func getCellForRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = getSectionType(indexPath.section) else { return UITableViewCell() }
        let cell: DebuggingViewManagerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(type.title)
        return cell
    }
}
