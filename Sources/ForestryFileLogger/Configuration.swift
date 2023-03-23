//
//  Copyright 2023 © Cleevio s.r.o. All rights reserved.
//

import Foundation
import ForestryLoggerLibrary

public extension FileLogger {
    struct Configuration {
        public init(
            logFileURL: URL? = nil,
            syncAfterEachWrite: Bool = false,
            fileManager: FileManager = .default,
            logFileMaxSize: Int = 1 * 1_024 * 1_024,
            dropFirst: Int = 1_000,
            dateFormatter: DateFormatter = ForestryLoggerFormatter.baseDateFormatter
        ) {
            self.logFileURL = logFileURL ?? fileManager.logFileURL()
            self.syncAfterEachWrite = syncAfterEachWrite
            self.fileManager = fileManager
            self.logFileMaxSize = logFileMaxSize
            self.dropFirst = dropFirst
            self.dateFormatter = dateFormatter
        }
        
        
        public var logFileURL: URL?
        public var syncAfterEachWrite: Bool
        public var fileManager: FileManager
        
        // how many bytes should a logfile have until it is trim?
        public var logFileMaxSize: Int
        public var dropFirst: Int
        public var dateFormatter: DateFormatter
    }
}

fileprivate extension FileManager {
    func logFileURL() -> URL? {
        var baseURL: URL?
        #if os(macOS)
            if let url = urls(for: .cachesDirectory, in: .userDomainMask).first {
                baseURL = url
                // try to use ~/Library/Caches/APP NAME instead of ~/Library/Caches
                if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
                    do {
                        if let appURL = baseURL?.appendingPathComponent(appName, isDirectory: true) {
                            try createDirectory(at: appURL,
                                                            withIntermediateDirectories: true, attributes: nil)
                            baseURL = appURL
                        }
                    } catch {
                        print("FileLogger: Warning! Could not create folder /Library/Caches/\(appName)")
                    }
                }
            }
        #elseif os(Linux)
                baseURL = URL(fileURLWithPath: "/var/cache")
        #else
        // iOS, watchOS, etc. are using the caches directory
        if let url = urls(for: .cachesDirectory, in: .userDomainMask).first {
            baseURL = url
        }
        #endif
        
        return baseURL?.appendingPathComponent("report.log", isDirectory: false)
    }
}
