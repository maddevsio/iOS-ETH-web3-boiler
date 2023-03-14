private typealias Module = Debugging.ViewManager

extension Module {
    typealias ViewManagerOutput = DebuggingViewManagingOutput
}

public protocol DebuggingViewManagingOutput: AnyObject {
    func didSelectItem(_ item: Debugging.DebuggingActions)
}
