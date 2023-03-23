import Foundation

/// Keys to set tags or parameters in services (or to be used during logging in these services)
/// Easily extendable by using a custom key.
public enum LogUserInfoKey: Hashable {
    case username
    case email
    case deviceID
    case sceneIdentifier
    case userID
    case buildNumber
    case custom(key: String, type: KeyType = .parameter)
    
    public var rawValue: String {
        switch self {
        case .username:
            return "username"
        case .email:
            return "email"
        case .deviceID:
            return "deviceID"
        case .sceneIdentifier:
            return "sceneIdentifier"
        case .userID:
            return "userID"
        case .buildNumber:
            return "buildNumber"
        case let .custom(key, _):
            return key
        }
    }

    public var type: KeyType {
        switch self {
        case .buildNumber:
            return .tag
        case .sceneIdentifier, .email, .username, .deviceID, .userID:
            return .parameter
        case let .custom(_, type):
            return type
        }
    }
}

extension LogUserInfoKey {
    /// The KeyType follows the naming from Datadog.
    /// Its use is logger per logger different, for example, for Sentry, both tags and parameters are set as tag()
    /// The type is not printed out in consoleLogger.
    public enum KeyType: Hashable {
        case tag
        case parameter
    }
}

public extension Dictionary where Key == LogUserInfoKey, Value == String {
    var stringKeyedDictionary: [String: String] {
        reduce(into: [:]) { result, element in
            result[element.key.rawValue] = element.value
        }
    }
}
