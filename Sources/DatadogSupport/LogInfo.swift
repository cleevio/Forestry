//
//  LogInfo+.swift
//  
//
//  Created by Lukáš Valenta on 10.01.2023.
//

import Foundation
import CleevioLoggerLibrary

#if canImport(Datadog)
import Datadog

extension LogInfo {
    var datadogAttributes: [AttributeKey: AttributeValue] {
        [
            DataDogAttributeKey.file.rawValue: file,
            DataDogAttributeKey.line.rawValue: line,
            DataDogAttributeKey.function.rawValue: function
        ]
    }
}

enum DataDogAttributeKey: String {
    case file
    case line
    case function
}
#endif
