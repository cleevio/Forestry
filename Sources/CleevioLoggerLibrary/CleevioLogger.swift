import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct CleevioLogger {
    private let loggerActor: LoggerActor?

    public init(services: [LoggerService]) {
        self.loggerActor = .init(services: services)
    }

    public init(service: LoggerService) {
        self.loggerActor = .init(services: [service])
    }

    // MARK: - Logging levels

    public func verbose(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .verbose, file: file, function: function, line: line)
    }

    public func debug(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }

    public func info(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    public func warning(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }

    public func error(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }

    public func setUserInfo(username: String?) {
        guard let loggerActor else { return }
        Task.detached {
            await loggerActor.setUserInfo(username: username)
        }
    }

    private func log(_ message: @escaping () -> Any, level: LogLevel, file: String, function: String, line: Int) {
        guard let loggerActor else { return }
        Task.detached(priority: .utility) { [message] in
            await loggerActor.log(message, level: level, file: file, function: function, line: line)
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private extension CleevioLogger {
    final actor LoggerActor {
        private let services: [LoggerService]

        init?(services: [LoggerService]) {
            guard !services.isEmpty else { return nil }
            self.services = services
        }
        
        func log(_ message: () -> Any, level: LogLevel, file: String, function: String, line: Int) {
            let availableServices = services.filter { $0.minimalLogLevel <= level }
            guard !availableServices.isEmpty else { return }
            let info = LogInfo(level: level, line: line, function: function, file: file, message: message(), icon: level.icon)
            availableServices.forEach { service in
                service.log(info: info)
            }
        }
    
        func setUserInfo(username: String?) {
            services.forEach { $0.configureUserInfo(username: username) }
        }
    }
}
