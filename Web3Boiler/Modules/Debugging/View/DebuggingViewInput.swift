private typealias Module = Debugging

public extension Module {
    typealias ViewInput = DebuggingViewInput
}

public protocol DebuggingViewInput: BaseViewInput {
    func display(viewModel: Debugging.ViewModel)
}
