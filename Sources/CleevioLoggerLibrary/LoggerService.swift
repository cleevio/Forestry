import Foundation

public protocol LoggerService {
    var minimalLogLevel: LogLevel { get set }

    func log(info: LogInfo)
    func configureUserInfo(_ dictionary: [LogUserInfoKey: String])
    func removeUserInfo(_ keys: [LogUserInfoKey])
}

extension LoggerService {
    @inlinable
    public func configureUserInfo(_ dictionary: [LogUserInfoKey : String]) {
        
    }
    
    @inlinable
    public func removeUserInfo(_ keys: [LogUserInfoKey]) {
        
    }
}
