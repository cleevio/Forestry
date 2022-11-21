public struct CleevioLogger {
    private let services: [LoggerService]

    public init(services: [LoggerService]) {
        guard !services.isEmpty else {
            fatalError("You can't create Logger without providing logging services!")
        }
        self.services = services
    }

    // MARK: - Logging levels

    public func verbose(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .verbose, file: file, function: function, line: line)
    }

    public func debug(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }

    public func info(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    public func warning(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }

    public func error(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }

    public func setUserInfo(username: String?) {
        services.forEach { $0.configureUserInfo(username: username) }
    }

    private func log(_ message: () -> Any, level: LogLevel, file: String, function: String, line: Int) {
        guard services.contains(where: { $0.minimalLogLevel >= level }) else { return }
        let info = LogInfo(level: level, line: line, function: function, file: file, message: message(), icon: level.icon)
        services.forEach { service in
            guard service.minimalLogLevel >= level else { return }
            service.log(info: info, level: level)
        }
    }
}
