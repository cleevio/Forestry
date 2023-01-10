//
//  File.swift
//  
//
//  Created by Lukáš Valenta on 10.01.2023.
//

import Foundation

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
    public enum KeyType: Hashable {
        case tag
        case parameter
    }
}
