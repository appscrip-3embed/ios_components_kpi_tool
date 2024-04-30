//
//  SignpostLog.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import os.signpost

final class SignpostLog {
    
    static let bundleId = "com.dheeredev.demoproject"
    
    /// point of interest log object
    static let pointOfInterestLog = OSLog(subsystem: bundleId, category: .pointsOfInterest)
    
    /// start sign post
    static func startSignPost(name: StaticString, _ format: StaticString = "", _ arguments: CVarArg...) -> OSSignpostID {
        let signPostID = OSSignpostID(log: pointOfInterestLog)
        os_signpost(.begin, log: pointOfInterestLog, name: name, signpostID: signPostID, format, arguments)
        return signPostID
    }
    
    /// event sign post
    static func eventSignPost(name: StaticString, signpostID: OSSignpostID, _ format: StaticString = "", _ arguments: CVarArg...) {
        os_signpost(.event, log: pointOfInterestLog, name: name, signpostID: signpostID, format, arguments)
    }
    
    /// end sign post
    static func endSignPost(name: StaticString, signpostID: OSSignpostID, _ format: StaticString = "", _ arguments: CVarArg...){
        os_signpost(.end, log: pointOfInterestLog, name: name, signpostID: signpostID, format, arguments)
    }
    
}
