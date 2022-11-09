import Foundation

public protocol LoggerService {
    var minimalLogLevel: CleevioLogLevel { get set }

    func log(info: LogInfo, level: CleevioLogLevel)
    func configureUserInfo(username: String?)
}
