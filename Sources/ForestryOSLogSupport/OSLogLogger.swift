//
//  OSLogLogger.swift
//  
//
//  Created by Lukáš Valenta on 12.06.2023.
//

import Foundation
import ForestryLoggerLibrary

#if canImport(OSLog)
import OSLog

/// An implementation of the `LoggerService` protocol that utilizes the OSLog framework for logging.
///
/// Use the `OSLogLogger` struct to log messages to the OSLog system. It conforms to the `LoggerService` protocol and provides a convenient way to configure logging settings and log messages.
///
/// Usage Example:
///
/// ```
/// let logger = OSLogLogger(
///     subsystem: "com.example.myapp",
///     minimalLogLevel: .verbose,
///     includesIconInMessage: true
/// )
/// logger.log(info: logInfo)
/// ```
///
/// - Note: The `OSLogLogger` requires macOS 11.0 or later and iOS 14.0 or later.
@available(macOS 11.0, iOS 14.0, *)
public struct OSLogLogger: LoggerService {
    
    /// The subsystem identifier for the OSLog logger.
    @usableFromInline
    let subsystem: String
    
    /// The logger instance for the OSLog logger.
    @usableFromInline
    let serviceLogger: Logger
    
    /// The minimal log level for the OSLog logger.
    public var minimalLogLevel: ForestryLoggerLibrary.LogLevel
    
    /// Determines whether to include an icon in the log message for the OSLog logger.
    public var includesIconInMessage: Bool
    
    /// Initializes an instance of `OSLogLogger`.
    ///
    /// - Parameters:
    ///   - subsystem: The subsystem identifier for the logger.
    ///   - minimalLogLevel: The minimal log level that this service should be used for.
    ///   - includesIconInMessage: Determines whether to include an icon in the log message.
    ///
    /// - Returns: An instance of `OSLogLogger`.
    @inlinable
    public init(subsystem: String,
                minimalLogLevel: ForestryLoggerLibrary.LogLevel,
                includesIconInMessage: Bool) {
        self.subsystem = subsystem
        self.minimalLogLevel = minimalLogLevel
        self.includesIconInMessage = includesIconInMessage
        self.serviceLogger = Logger(subsystem: subsystem, category: "OSLogLogger")
    }
    
    /// Logs the provided log information to the OSLog logger.
    ///
    /// - Parameter info: The log information.
    public func log(info: ForestryLoggerLibrary.LogInfo) {
        let logger = Logger(subsystem: subsystem, category: info.file)
        logger.log(level: info.asOSLogType(), "\(info.asStringForOSLog(withIcon: includesIconInMessage))")
    }

    /// Logs userInfo dictionary
    ///
    /// - Parameter dictionary: The dictionary of user info key-value pairs.
    public func configureUserInfo(_ dictionary: [LogUserInfoKey : String]) {
        serviceLogger.info("Configured userInfo dictionary: \(dictionary)")
    }
    
    /// Logs removed userInfo keys
    ///
    /// - Parameter keys: The keys for which to remove user info.
    public func removeUserInfo(_ keys: [LogUserInfoKey]) {
        serviceLogger.info("Removed userInfo keys: \(keys)")
    }
}

@available(macOS 11.0, iOS 14.0, *)
public extension LoggerService where Self == OSLogLogger {
    /// Creates a default instance of `OSLogLogger` using the main bundle identifier as the subsystem.
    ///
    /// - Returns: A default instance of `OSLogLogger` with default parameters.
    @inlinable
    static var osLog: OSLogLogger {
        .osLog()
    }
    
    /// Creates an instance of `OSLogLogger` with the specified configuration.
    ///
    /// - Parameters:
    ///   - subsystem: The subsystem identifier for the logger. Default is `Bundle.main.bundleIdentifier ?? "Application"`.
    ///   - minimalLogLevel: The minimal log level that this service should be used for. Default is `.verbose`.
    ///   - includesIconInMessage: Determines whether to include an icon in the log message. Default is `true`.
    ///
    /// - Returns: An instance of `OSLogLogger` with the specified configuration.
    @inlinable
    static func osLog(subsystem: String = Bundle.main.bundleIdentifier ?? "Application",
                      minimalLogLevel: ForestryLoggerLibrary.LogLevel = .verbose,
                      includesIconInMessage: Bool = true) -> OSLogLogger {
        OSLogLogger(
            subsystem: subsystem,
            minimalLogLevel: minimalLogLevel,
            includesIconInMessage: includesIconInMessage
        )
    }
}

@available(macOS 11.0, iOS 14.0, *)
private extension LogInfo {
    func asStringForOSLog(withIcon: Bool) -> String {
        "\(withIcon ? "\(icon) " : "")\(line) \(function) > \(message)"
    }

    func asOSLogType() -> OSLogType {
        switch level {
        case .verbose, .debug:
            return .debug
        case .info:
            return .info
        case .warning, .error:
            return .error
        }
    }
}
#endif
