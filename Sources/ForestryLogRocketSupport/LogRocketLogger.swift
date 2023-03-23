//
//  Copyright 2023 © Cleevio s.r.o. All rights reserved.
//

import Foundation
import ForestryLoggerLibrary

#if canImport(LogRocket)
import LogRocket

/// Sends all logs to the Log Rocket cloud.
public struct LogRocketLogger: LoggerService {

    public var minimalLogLevel: ForestryLoggerLibrary.LogLevel = .debug

    public init(appID: String) {
        let config = Configuration(appID: appID)
        LogRocket.SDK.initialize(configuration: config)
    }

    @inlinable
    public func log(info: LogInfo) {
        switch info.level {
        case .verbose, .debug:
            Logger.debug(message: info.formattedMessage)
        case .info:
            Logger.info(message: info.formattedMessage)
        case .warning:
            Logger.warning(message: info.formattedMessage)
        case .error:
            Logger.error(message: info.formattedMessage)
        }
    }

    public func configureUserInfo(_ dictionary: [LogUserInfoKey : String]) {
        var userInfo: [String: String] = dictionary.stringKeyedDictionary
        userInfo.removeValue(forKey: LogUserInfoKey.userID.rawValue)

        guard let userID = dictionary[.userID] else {
            LogRocket.SDK.identifyAsAnonymous(userID: UUID().uuidString, userInfo: userInfo)
            return
        }
        LogRocket.SDK.identify(userID: userID, userInfo: userInfo)
    }
}

public extension LoggerService where Self == LogRocketLogger {
    @inlinable
    static func logRocket(appID: String) -> LogRocketLogger {
        .init(appID: appID)
    }
}
#endif
