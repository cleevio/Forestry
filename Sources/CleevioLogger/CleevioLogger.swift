public struct CleevioLogger {
    private let services: [LoggerService]

    public init(services: [LoggerService]) {
        guard !services.isEmpty else {
            fatalError("You can't create Logger without providing logging services!")
        }
        self.services = services
    }

    // MARK: - Logging levels

    public func verbose(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let info = LogInfo(line: line, function: function, file: file, message: "\(message)", icon: "📢")
        services.forEach { $0.log(info: info, level: .verbose) }
    }

    public func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let info = LogInfo(line: line, function: function, file: file, message: "\(message)", icon: "✅")
        services.forEach { $0.log(info: info, level: .debug) }
    }

    public func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let info = LogInfo(line: line, function: function, file: file, message: "\(message)", icon: "ℹ️")
        services.forEach { $0.log(info: info, level: .info) }
    }

    public func warning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let info = LogInfo(line: line, function: function, file: file, message: "\(message)", icon: "⚠️")
        services.forEach { $0.log(info: info, level: .warning) }
    }

    public func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let info = LogInfo(line: line, function: function, file: file, message: "\(message)", icon: "🛑")
        services.forEach { $0.log(info: info, level: .error) }
    }

    public func setUserInfo(username: String?) {
        services.forEach { $0.configureUserInfo(username: username) }
    }
}
