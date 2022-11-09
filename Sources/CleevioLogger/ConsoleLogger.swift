import Foundation

/// Prints all logs to the Console.
public struct ConsoleLogger: LoggerService {
    private let formatter: DateFormatter = {
        let rVal = DateFormatter()
        rVal.dateFormat = "HH:mm:ss.SSS"
        return rVal
    }()

    public var minimalLogLevel: CleevioLogLevel = .verbose

    public init() {}

    public func log(info: LogInfo, level: CleevioLogLevel) {
        guard level >= minimalLogLevel else { return }
        print("\(formatter.string(from: info.date)) \(info.formattedMessage)")
    }

    public func configureUserInfo(username: String?) {}
}
