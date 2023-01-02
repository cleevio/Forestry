//
//  CleevioLoggerFormatter.swift
//  
//
//  Created by Lukáš Valenta on 02.01.2023.
//

import Foundation

public enum CleevioLoggerFormatter {
    public static let baseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
