import Foundation

public protocol LoggerService {
    var minimalLogLevel: LogLevel { get set }

    func log(info: LogInfo, level: LogLevel)
    func configureUserInfo(username: String?)
}
