#if canImport(Datadog)
import Foundation
import Datadog

/// Sends all logs to the Datadog.
public class DDLogger: LoggerService {

    private let clientToken: String
    private let logger: Logger
    private var username: String?

    public init(clientToken: String) {
        self.clientToken = clientToken
        Datadog.initialize(appContext: .init(),
                           trackingConsent: .granted,
                           configuration: Datadog.Configuration.builderUsing(clientToken: clientToken, environment: EnvironmentConfiguration.current.environment.rawValue).build()
        )

        logger = Logger.builder
            .sendNetworkInfo(true)
            .sendLogsToDatadog(true)
            .printLogsToConsole(false)
            .build()
    }

    public func log(info: LogInfo, level: LogLevel) {
        switch level {
        case .verbose:
            logger.notice(info.formattedMessage, attributes: defaultAttributes)
        case .debug:
            logger.debug(info.formattedMessage, attributes: defaultAttributes)
        case .info:
            logger.info(info.formattedMessage, attributes: defaultAttributes)
        case .warning:
            logger.warn(info.formattedMessage, attributes: defaultAttributes)
        case .error:
            logger.error(info.formattedMessage, attributes: defaultAttributes)
        }
    }

    private var defaultAttributes: [AttributeKey: AttributeValue]? {
        guard let username = username else {
            return nil
        }

        return ["username": username]
    }

    public func configureUserInfo(username: String?) {
        self.username = username
    }
}
#endif
