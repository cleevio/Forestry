import Foundation

public protocol LoggerService {
    func log(info: LogInfo, level: LogLevel)
    func configureUserInfo(username: String?)
}
