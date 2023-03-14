public struct Debugging {
    public typealias Configuration = (ModuleInput) -> ModuleOutput?

    public typealias ModuleInput = DebuggingModuleInput
    public typealias ModuleOutput = DebuggingModuleOutput
}

public extension Debugging {
    struct ConfigData {}
}

public protocol DebuggingModuleInput: AnyObject {
    func configure(_ data: Debugging.ConfigData)
}

public protocol DebuggingModuleOutput: AnyObject {
}
