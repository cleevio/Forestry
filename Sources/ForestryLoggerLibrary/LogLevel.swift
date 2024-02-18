//
//  Copyright 2023 © Cleevio s.r.o. All rights reserved.
//


/// A level of log that determines to which services should the message be logged to
/// LogLevel also includes the icon that is used within a formatted message
public enum LogLevel: Int, Comparable, Sendable {
    case verbose
    case debug
    case info
    case warning
    case error

    @inlinable
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var icon: String {
        switch self {
        case .verbose:
            return "📢"
        case .debug:
            return "✅"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "🛑"
        }
    }
}
