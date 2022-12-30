//
//  FileLogger.swift
//  
//
//  Created by Lukáš Valenta on 30.12.2022.
//

import Foundation
import CleevioLoggerLibrary

public struct FileLogger: LoggerService {
    
    public var minimalLogLevel: CleevioLoggerLibrary.LogLevel
    public var configuration: Configuration

    private var fileManager: FileManager {
        configuration.fileManager
    }

    private let formatter: DateFormatter = {
        let rVal = DateFormatter()
        rVal.dateFormat = "HH:mm:ss.SSS"
        return rVal
    }()

    public init(minimalLogLevel: LogLevel = .debug, configuration: Configuration = .init()) {
        self.minimalLogLevel = minimalLogLevel
        self.configuration = configuration
    }
        
    public func log(info: CleevioLoggerLibrary.LogInfo) {
        if !saveToValidatedFile(message: "\(formatter.string(from: info.date)) \(info.formattedMessage)") {
            print("FileLogger: Unable to write to file")
        }
    }
    
    public func configureUserInfo(username: String?) { }
    
    /// check if filesize is bigger than wanted and if yes then rotate them
    func saveToValidatedFile(message: String) -> Bool {
        guard let url = configuration.logFileURL else { return false }
        let filePath = url.path
        if fileManager.fileExists(atPath: filePath) == true {
            do {
                var fileSize = try getFileSize(atPath: filePath)
                while fileSize > configuration.logFileMaxSize {
                    trimFile(url)
                    fileSize = try getFileSize(atPath: filePath)
                }
            } catch {
                print("FileLogger: validateSaveFile error: \(error)")
            }
        }

        return saveToFile(message: message)
    }

    private func getFileSize(atPath filePath: String) throws -> UInt64 {
        let attr = try fileManager.attributesOfItem(atPath: filePath)
        return attr[FileAttributeKey.size] as! UInt64
    }

    private func trimFile(_ logFileURL: URL) {
       do {
           let data = try Data(contentsOf: logFileURL, options: .mappedIfSafe)
           guard let trimmedData = String(decoding: data, as: UTF8.self)
                    .components(separatedBy: "\n")
                    .dropFirst(configuration.dropFirst)
                    .joined(separator: "\n")
                    .data(using: .utf8) else {
                        return
                    }

           try trimmedData.write(to: logFileURL, options: .atomic)
       } catch {
           print("FileLogger: trimFile error: \(error)")
       }
    }

    /// appends a string as line to a file.
    /// returns boolean about success
    private func saveToFile(message: String) -> Bool {
        guard let url = configuration.logFileURL else { return false }

        let line = message + "\n"
        guard let data = line.data(using: String.Encoding.utf8) else { return false }

        return write(data: data, to: url)
    }

    private func write(data: Data, to url: URL) -> Bool {
        #if os(Linux)
        // Needs to be implemented
        return false
        #else
        var success = false
        let coordinator = NSFileCoordinator(filePresenter: nil)
        var error: NSError?
        coordinator.coordinate(writingItemAt: url, error: &error) { url in
            do {
                if fileManager.fileExists(atPath: url.path) == false {

                    let directoryURL = url.deletingLastPathComponent()
                    if fileManager.fileExists(atPath: directoryURL.path) == false {
                        try fileManager.createDirectory(
                            at: directoryURL,
                            withIntermediateDirectories: true
                        )
                    }
                    fileManager.createFile(atPath: url.path, contents: nil)

                    #if os(iOS) || os(watchOS)
                    if #available(iOS 10.0, watchOS 3.0, *) {
                        var attributes = try fileManager.attributesOfItem(atPath: url.path)
                        attributes[FileAttributeKey.protectionKey] = FileProtectionType.none
                        try fileManager.setAttributes(attributes, ofItemAtPath: url.path)
                    }
                    #endif
                }

                let fileHandle = try FileHandle(forWritingTo: url)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                if configuration.syncAfterEachWrite {
                    fileHandle.synchronizeFile()
                }
                fileHandle.closeFile()
                success = true
            } catch {
                print("FileLogger could not write to file \(url).")
            }
        }

        if let error = error {
            print("FileLogger: Failed writing file with error: \(String(describing: error))")
            return false
        }

        return success
        #endif
    }

    /// deletes log file.
    /// returns true if file was removed or does not exist, false otherwise
    public func deleteLogFile() -> Bool {
        guard let url = configuration.logFileURL, fileManager.fileExists(atPath: url.path) else { return true }
        do {
            try fileManager.removeItem(at: url)
            return true
        } catch {
            print("FileLogger could not remove file \(url).")
            return false
        }
    }
}

public extension LoggerService where Self == FileLogger {
    static var file: FileLogger { .init() }

    static func file(minimalLogLevel: LogLevel = .debug, configuration: FileLogger.Configuration = .init()) -> FileLogger {
        .init(minimalLogLevel: minimalLogLevel, configuration: configuration)
    }
}
