import Foundation

/// A logger that stores its services in a an actor from which all logging is executed asynchronously.
/// If no service is provided (e.g. for production), the logging library should be free to use without any performance detriments (with only one if check)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct CleevioLogger {
    private let loggerActor: LoggerActor?
    
    /// Can be called with empty array. In such situation, the logger will be efficient to use without resolving the messages
    public init(services: [LoggerService]) {
        self.loggerActor = .init(services: services)
    }
    
    @inlinable
    public init(service: LoggerService) {
        self.init(services: [service])
    }

    /// Logs the message in services based on minimumLogLevel.
    /// The log may be executed from a different Thread than the one that called the function as the logging happens asynchronously.
    public func log(_ message: @escaping () -> Any, level: LogLevel, file: String, function: String, line: Int) {
        guard let loggerActor else { return }
        Task.detached(priority: .utility) { [message] in
            await loggerActor.log(message, level: level, file: file, function: function, line: line)
        }
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

    // MARK: - UserInfo

    /// Updates user info values for provided keys in each logging service.
    /// It is not necessary to call it with previously set key value pairs.
    public func updateUserInfo(for dictionary: [LogUserInfoKey: String]) {
        guard let loggerActor else { return }
        Task.detached {
            await loggerActor.updateUserInfo(for: dictionary)
        }
    }

    /// Removes previously set userinfo for provided keys in each logging service
    public func removeUserInfo(for keys: [LogUserInfoKey]) {
        guard let loggerActor else { return }
        Task.detached {
            await loggerActor.removeUserInfo(for: keys)
        }
    }
    
    /// Updates user info values for provided key in each logging service.
    @inlinable
    public func updateUserInfo(for key: LogUserInfoKey, with value: String) {
        updateUserInfo(for: [key: value])
    }

    /// Removes previously set userinfo for provided key in each logging service
    @inlinable
    public func removeUserInfo(for key: LogUserInfoKey) {
        removeUserInfo(for: [key])
    }
    
    public func currentUserInfo() async -> [LogUserInfoKey: String] {
        await loggerActor?.userInfo ?? [:]
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private extension CleevioLogger {
    final actor LoggerActor {
        private let services: [LoggerService]
        var userInfo: [LogUserInfoKey: String] = [:]

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
    @inlinable
    @available(*, deprecated, message: "Use updateUserInfo() instead")
    public func setUserInfo(_ dictionary: [LogUserInfoKey: String]) {
        updateUserInfo(for: dictionary)
    }

    @inlinable
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
