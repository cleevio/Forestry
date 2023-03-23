import Foundation

public protocol LoggerService {
    /// A minimal log level that this service should be used for.
    var minimalLogLevel: LogLevel { get set }

    /// Logs the message in services based on minimumLogLevel.
    /// The log may be executed from a different Thread than the one that called the function as the logging happens asynchronously.
    func log(info: LogInfo)
    
    /// Updates user info values for provided keys in each logging service.
    /// It is not necessary to call it with previously set key value pairs.
    func configureUserInfo(_ dictionary: [LogUserInfoKey: String])
    
    /// Removes previously set userinfo for provided keys in each logging service
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
