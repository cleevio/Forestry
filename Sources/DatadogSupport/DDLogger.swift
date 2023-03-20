import Foundation
import CleevioLoggerLibrary

#if canImport(Datadog)
import Datadog

/// Sends all logs to the Datadog.
public class DDLogger: LoggerService {

    private let clientToken: String
    private let logger: Logger
    private var userInfo: [AttributeKey: String] = [:]
    public var minimalLogLevel: CleevioLoggerLibrary.LogLevel = .verbose

    public init(
        clientToken: String,
        environment: String,
        serviceName: String,
        trackingConsent: TrackingConsent,
        uploadFrequency: Datadog.Configuration.UploadFrequency
    ) {
        self.clientToken = clientToken

        Datadog.initialize(
            appContext: .init(),
            trackingConsent: trackingConsent,
            configuration: Datadog.Configuration.builderUsing(
                clientToken: clientToken,
                environment: environment)
            .set(uploadFrequency: uploadFrequency)
            .build()
        )

        logger = Logger.builder
            .set(serviceName: serviceName)
            .sendNetworkInfo(true)
            .sendLogsToDatadog(true)
            .printLogsToConsole(false)
            .build()
    }

    public func log(info: CleevioLoggerLibrary.LogInfo) {
        var attributes = info.datadogAttributes
        
        for (key, value) in userInfo {
            attributes[key] = value
        }
        
        logger.log(level: info.datadogLogLevel, message: info.formattedMessage, error: nil, attributes: attributes)
    }

    public func configureUserInfo(_ dictionary: [LogUserInfoKey : String]) {
        for (key, value) in dictionary {
            switch key.type {
            case .tag:
                logger.addTag(withKey: key.rawValue, value: value)
            case .parameter:
                userInfo[key.rawValue] = value
            }
        }
    }
    
    public func removeUserInfo(_ keys: [LogUserInfoKey]) {
        for key in keys {
            switch key.type {
            case .parameter:
                userInfo[key.rawValue] = nil
            case .tag:
                logger.removeTag(withKey: key.rawValue)
            }
        }
    }
}

public extension LoggerService where Self == DDLogger {
    @inlinable
    static func datadog(
        clientToken: String,
        environment: String,
        serviceName: String,
        trackingConsent: TrackingConsent = .granted,
        uploadFrequency: Datadog.Configuration.UploadFrequency = .average
    ) -> DDLogger {
        .init(
                clientToken: clientToken,
                environment: environment,
                serviceName: serviceName,
                trackingConsent: trackingConsent,
                uploadFrequency: uploadFrequency
        )
    }
}
#endif
