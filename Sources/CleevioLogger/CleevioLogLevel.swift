public enum CleevioLogLevel: Int, Comparable {
    case verbose
    case debug
    case info
    case warning
    case error

    public static func < (lhs: CleevioLogLevel, rhs: CleevioLogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
