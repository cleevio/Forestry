//
//  Copyright 2023 © Cleevio s.r.o. All rights reserved.
//

import Foundation
#if canImport(DatadogCore)
import DatadogCore
import DatadogLogs

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
#endif
