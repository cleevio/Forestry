import Foundation
import CleevioLoggerLibrary
import Sentry

/// Sends error logs to the Sentry
public struct SentryLogger: LoggerService {

    public var minimalLogLevel: CleevioLoggerLibrary.LogLevel = .error

    public init(options: Options) {
        SentrySDK.start(options: options)
    }

    public func log(info: LogInfo) {
        let event = Event()
        event.message = SentryMessage(formatted: info.formattedMessage)
        event.level = info.level.asSentryLevel
        SentrySDK.capture(event: event)
    }
}

private extension LogLevel {
    var asSentryLevel: SentryLevel {
        switch self {
        case .verbose:
            return .none
        case .debug:
            return .debug
        case .info:
            return .info
        case .warning:
            return .warning
        case .error:
            return .error
        }
    }
}
