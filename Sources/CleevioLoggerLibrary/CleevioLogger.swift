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
    
    @inlinable
    public func verbose(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .verbose, file: file, function: function, line: line)
    }
    
    @inlinable
    public func debug(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    @inlinable
    public func info(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    @inlinable
    public func warning(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    @inlinable
    public func error(_ message: @escaping @autoclosure () -> Any, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }

    public func updateUserInfo(for values: [LogUserInfoKey: String]) {
        guard let loggerActor else { return }
        Task.detached {
            await loggerActor.updateUserInfo(for: values)
        }
    }

    public func removeUserInfo(for keys: [LogUserInfoKey]) {
        guard let loggerActor else { return }
        Task.detached {
            await loggerActor.removeUserInfo(for: keys)
        }
    }

    public func removeUserInfo(for key: LogUserInfoKey) {
        removeUserInfo(for: [key])
    }

    public func log(_ message: @escaping () -> Any, level: LogLevel, file: String, function: String, line: Int) {
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
        private var userInfo: [LogUserInfoKey: String] = [:]

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
    
        func updateUserInfo(for dictionary: [LogUserInfoKey: String]) {
            for (key, value) in dictionary {
                userInfo[key] = value
            }
            services.forEach { $0.configureUserInfo(userInfo) }
        }

        func removeUserInfo(for keys: [LogUserInfoKey]) {
            keys.forEach { userInfo[$0] = nil }
            services.forEach {
                $0.removeUserInfo(keys)
                $0.configureUserInfo(userInfo)
            }
        }
    }
}

// MARK: - Deprecated
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CleevioLogger {
    @available(*, deprecated, message: "Use updateUserInfo() instead")
    public func setUserInfo(_ dictionary: [LogUserInfoKey: String]) {
        updateUserInfo(for: dictionary)
    }

    @available(*, deprecated, message: "Use `removeUserInfo()` instead")
    public func removeValues(for keys: [LogUserInfoKey]) {
        removeUserInfo(for: keys)
    }

    @inlinable
    @available(*, deprecated, message: "Use setUserInfo() instead")
    public func setUserInfo(username: String?) {
        guard let username else { return removeValue(for: .username)}
        let dictionary: [LogUserInfoKey: String] = [
            .username: username
        ]
        setUserInfo(dictionary)
    }

    @inlinable
    @available(*, deprecated, message: "Use removeUserInfo() instead")
    public func removeValue(for key: LogUserInfoKey) {
        removeUserInfo(for: [key])
    }
}
