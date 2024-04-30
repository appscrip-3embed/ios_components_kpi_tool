//
//  Logger.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import Foundation
import os.log

enum LogLevel {
    case debug
    case info
    case warning
    case error
    
    func osLogType() -> OSLogType {
        switch self {
        case .debug:
            return .debug
        case .info:
            return .info
        case .warning:
            return .default
        case .error:
            return .error
        }
    }
    
}

struct CustomLogger {
    static var logLevel: LogLevel = .debug // Default log level
    
    static func log(_ level: LogLevel, _ message: String, file: String = #file, line: Int = #line, function: String = #function) {
        guard level.osLogType().rawValue >= logLevel.osLogType().rawValue else {
            return
        }
        
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "CustomLogger")
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(fileName):\(line) \(function) - \(message)"
        
        switch level {
        case .debug:
            os_log("%@", log: log, type: .debug, logMessage)
        case .info:
            os_log("%@", log: log, type: .info, logMessage)
        case .warning:
            os_log("%@", log: log, type: .default, logMessage)
        case .error:
            os_log("%@", log: log, type: .error, logMessage)
        }
    }
}
