public enum LogLevel: Int, Comparable {
    case verbose
    case debug
    case info
    case warning
    case error

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
