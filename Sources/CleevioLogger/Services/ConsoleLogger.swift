import Foundation

/// Prints all logs to the Console.
public struct ConsoleLogger: LoggerService {
    private let formatter: DateFormatter = {
        let rVal = DateFormatter()
        rVal.dateFormat = "HH:mm:ss.SSS"
        return rVal
    }()

    public init() {}

    public func log(info: LogInfo, level: LogLevel) {
        print("\(formatter.string(from: info.date)) \(info.formattedMessage)")
    }

    public func configureUserInfo(username: String?) {}
}
