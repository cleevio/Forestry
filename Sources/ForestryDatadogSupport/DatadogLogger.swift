//
//  Copyright 2023 © Cleevio s.r.o. All rights reserved.
//

import Foundation
import ForestryLoggerLibrary

#if canImport(DatadogCore)
import DatadogCore
import DatadogInternal
import DatadogLogs

/// A logger that sends all logs to the Datadog.
public class DatadogLogger: LoggerService {

    private let clientToken: String
    private let logger: any LoggerProtocol
    private var userInfo: [AttributeKey: String] = [:]
    public var minimalLogLevel: ForestryLoggerLibrary.LogLevel = .verbose

    public init(
        clientToken: String,
        environment: String,
        serviceName: String,
        trackingConsent: TrackingConsent,
        uploadFrequency: Datadog.Configuration.UploadFrequency
    ) {
        self.clientToken = clientToken

        let core = Datadog.initialize(
            with: .init(
                clientToken: clientToken,
                env: environment,
                service: serviceName,
                uploadFrequency: uploadFrequency
            ),
            trackingConsent: trackingConsent
        )

        Logs.enable(in: core)
        
        logger = Logger.create(
            with: .init(
                service: serviceName,
                networkInfoEnabled: true,
                consoleLogFormat: .none),
            in: core
        )
    }

    public func log(info: ForestryLoggerLibrary.LogInfo) {
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

public extension LoggerService where Self == DatadogLogger {
    /// A logger that sends all logs to the Datadog.
    @inlinable
    static func datadog(
        clientToken: String,
        environment: String,
        serviceName: String,
        trackingConsent: TrackingConsent = .granted,
        uploadFrequency: Datadog.Configuration.UploadFrequency = .average
    ) -> DatadogLogger {
        .init(
                clientToken: clientToken,
                environment: environment,
                serviceName: serviceName,
                trackingConsent: trackingConsent,
                uploadFrequency: uploadFrequency
        )
    }
}

#else

@available(*, unavailable, message: "DatadogLogger is not available for this platform")
public class DatadogLogger: LoggerService {
    public var minimalLogLevel: ForestryLoggerLibrary.LogLevel = .debug
    
    public func log(info: ForestryLoggerLibrary.LogInfo) {
        
    }
    
    
}
#endif
