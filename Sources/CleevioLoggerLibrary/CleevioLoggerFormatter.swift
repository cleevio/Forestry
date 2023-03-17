import Foundation

public enum CleevioLoggerFormatter {
    public static let baseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
