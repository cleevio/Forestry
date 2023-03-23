//
//  Copyright 2023 © Cleevio s.r.o. All rights reserved.
//

import Foundation

public enum ForestryLoggerFormatter {
    public static let baseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
