//
//  Logs.swift
//  FetchDesertReward
//
//  Created by Bill Calkins on 6/17/22.
//

import Foundation
import os

// MARK: - Universal Logging
private let subsystem = "com.c3.NavgatingFood"

struct Log {
    //create log for decoding data structures
    static let decodingLogger = Logger(subsystem: subsystem, category: "decoding")
    static let fileSystemLogger = Logger(subsystem: subsystem, category: "filesystem")
    static let networkLogger = Logger(subsystem: subsystem, category: "network")
    static let viewLogger = Logger(subsystem: subsystem, category: "views")
    static let viewModelLogger = Logger(subsystem: subsystem, category: "viewModels")
    static let modelLogger = Logger(subsystem: subsystem, category: "models")
    static let unknownErrorLogger = Logger(subsystem: subsystem, category: "unknown")
}
