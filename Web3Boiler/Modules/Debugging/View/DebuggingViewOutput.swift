private typealias Module = Debugging

public extension Module {
    typealias ViewOutput = DebuggingViewOutput
}

public protocol DebuggingViewOutput {
    func viewDidLoad()
    func itemSelected(_ item: Debugging.DebuggingActions)
}
