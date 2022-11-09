#if canImport(SwiftyBeaver)
import Foundation
import SwiftyBeaver

/// Sends all logs to the Swift Beaver cloud.
public struct SwiftyBeaverLogger: LoggerService {

    private let logger = SwiftyBeaver.self
    private let cloudLogger: SBPlatformDestination

    public init(cloudLogger: SBPlatformDestination) {
        self.cloudLogger = cloudLogger
        logger.addDestination(cloudLogger)
    }

    public func log(info: LogInfo, level: LogLevel) {
        guard level >= minimalLogLevel else { return }
        switch level {
        case .verbose:
            logger.verbose(
                info.message(), info.file, info.function, line: info.line, context: Thread.current.debugDescription)
        case .debug:
            logger.debug(
                info.message(), info.file, info.function, line: info.line, context: Thread.current.debugDescription)
        case .info:
            logger.info(
                info.message(), info.file, info.function, line: info.line, context: Thread.current.debugDescription)
        case .warning:
            logger.warning(
                info.message(), info.file, info.function, line: info.line, context: Thread.current.debugDescription)
        case .error:
            logger.error(
                info.message(), info.file, info.function, line: info.line, context: Thread.current.debugDescription)
        }
    }

    public func configureUserInfo(username: String?) {
        guard let username = username else {
            return
        }
        cloudLogger.analyticsUserName = username
    }
}
#endif
