import Foundation

/// Prints all logs to the Console.
public struct ConsoleLogger: LoggerService {
    public var minimalLogLevel: LogLevel = .verbose
    public var dateFormatter: DateFormatter

    public init(dateFormatter: DateFormatter = CleevioLoggerFormatter.baseDateFormatter) {
        self.dateFormatter = dateFormatter
    }

    @inlinable
    public func log(info: LogInfo) {
        print("\(dateFormatter.string(from: info.date)) \(info.formattedMessage)")
    }
}

public extension LoggerService where Self == ConsoleLogger {
    static var console: ConsoleLogger { .init() }
}
