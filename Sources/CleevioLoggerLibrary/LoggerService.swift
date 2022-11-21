import Foundation

public protocol LoggerService {
    var minimalLogLevel: LogLevel { get set }

    func log(info: LogInfo)
    func configureUserInfo(username: String?)
}
