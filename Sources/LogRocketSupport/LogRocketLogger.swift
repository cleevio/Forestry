import Foundation
import LogRocket
import CleevioLoggerLibrary

/// Sends all logs to the Log Rocket cloud.
public struct LogRocketLogger: LoggerService {

    public var minimalLogLevel: CleevioLoggerLibrary.LogLevel = .debug

    public init(appID: String) {
        let config = Configuration(appID: appID)
        SDK.initialize(configuration: config)
    }

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
        var userInfo: [String: String] = dictionary.reduce(into: [:]) { result, element in
            result[element.key.rawValue] = element.value
        }
        userInfo.removeValue(forKey: LogUserInfoKey.userID.rawValue)

        guard let userID = dictionary[.userID] else {
            SDK.identifyAsAnonymous(userID: UUID().uuidString, userInfo: userInfo)
            return
        }
        SDK.identify(userID: userID, userInfo: userInfo)
    }
}
