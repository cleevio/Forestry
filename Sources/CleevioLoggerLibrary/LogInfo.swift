import Foundation

/// Detail info about log (unformatted)
public struct LogInfo {
    public var line: Int
    public var function: String
    public var file: String
    /// Raw message
    public var message: () -> Any
    public var icon: String
    public var date = Date()

    /// Unified message format: `✅ AppDelegate:80 value(forKey:) > Raw message`
    public var formattedMessage: String {
        return "\(icon) \(file):\(line) \(function) > \(message())"
    }

    public init(line: Int, function: String, file: String, message: @escaping () -> Any, icon: String) {
        self.line = line
        self.function = function
        self.file = Self.normalizeFileName(file: file)
        self.message = message
        self.icon = icon
    }

    private static func normalizeFileName(file: String) -> String {
        // swiftlint:disable:next force_unwrapping
        file.components(separatedBy: "/").last!.replacingOccurrences(of: ".swift", with: "")
    }
}
