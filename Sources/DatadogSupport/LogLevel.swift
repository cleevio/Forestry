//
//  File.swift
//  
//
//  Created by Lukáš Valenta on 18.03.2023.
//

import Foundation
import Datadog

// Extension cannot be made on LogLevel, as there is no way to reference Datadog.LogLevel
extension LogInfo {
    var datadogLogLevel: LogLevel {
        switch level {
        case .info:
            return .info
        case .error:
            return .error
        case .warning:
            return .warn
        case .debug:
            return .debug
        case .verbose:
            return .notice
        }
    }
}
