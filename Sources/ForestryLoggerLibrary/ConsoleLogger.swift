import Foundation

/// A logger that prints all logs to the Console.
public struct ConsoleLogger: LoggerService {
    public var minimalLogLevel: LogLevel = .verbose
    public var dateFormatter: DateFormatter

    public init(dateFormatter: DateFormatter = ForestryLoggerFormatter.baseDateFormatter) {
        self.dateFormatter = dateFormatter
    }

    @inlinable
    public func log(info: LogInfo) {
        print("\(dateFormatter.string(from: info.date)) \(info.formattedMessage)")
    }

    @inlinable
    public func configureUserInfo(_ dictionary: [LogUserInfoKey : String]) {
        print("Configured userInfo dictionary:", dictionary)
    }
    
    @inlinable
    public func removeUserInfo(_ keys: [LogUserInfoKey]) {
        print("Removed userInfo keys:", keys)
    }
}

public extension LoggerService where Self == ConsoleLogger {
    /// A logger that prints all logs to the Console.
    static var console: ConsoleLogger { .init() }
}
