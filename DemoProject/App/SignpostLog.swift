//
//  SignpostLog.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import os.signpost

final class SignpostLog {
    
    static let bundleId = "com.dheerajdev.demoproject"
    
    /// general log object
    static let log = OSLog(subsystem: bundleId, category: "general")
    
    /// networking log object
    static let networkingLog = OSLog(subsystem: bundleId, category: "Networking")
    
    static func getSignPostID(log: OSLog) -> OSSignpostID {
        return OSSignpostID(log: log)
    }
    
    /// start sign post
    static func startSignPost(name: StaticString,signpostID: OSSignpostID, log: OSLog, _ format: StaticString = "", _ arguments: CVarArg...) {
        os_signpost(.begin, log: log, name: name, signpostID: signpostID, format, arguments)
    }
    
    /// event sign post
    static func eventSignPost(name: StaticString, log: OSLog, signpostID: OSSignpostID, _ format: StaticString = "", _ arguments: CVarArg...) {
        os_signpost(.event, log: log, name: name, signpostID: signpostID, format, arguments)
    }
    
    /// end sign post
    static func endSignPost(name: StaticString, log: OSLog, signpostID: OSSignpostID, _ format: StaticString = "", _ arguments: CVarArg...){
        os_signpost(.end, log: log, name: name, signpostID: signpostID, format, arguments)
    }
    
}
