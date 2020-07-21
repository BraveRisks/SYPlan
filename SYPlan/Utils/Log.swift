//
//  Log.swift
//  SYPlan
//
//  Created by Ray on 2020/7/21.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit
import os.log

struct Log {
    
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
    
    enum Category: String {
        
        /// 其他
        case other = "Other"
    }
    
    /// Log level is debug
    /// - Parameters:
    ///   - message: description
    ///   - category: log category
    static func debug(message: StaticString, category: Category) {
        if #available(iOS 10.0, *) {
            os_log(message,
                   log: OSLog(subsystem: subsystem,
                              category: category.rawValue),
                   type: .debug)
        } else {
            #if DEBUG
            print("[\(category.rawValue)] \(message)")
            #endif
        }
    }
    
    /// Log level is info
    /// - Parameters:
    ///   - message: description
    ///   - category: log category
    static func info(message: StaticString, category: Category) {
        if #available(iOS 10.0, *) {
            os_log(message,
                   log: OSLog(subsystem: subsystem,
                              category: category.rawValue),
                   type: .info)
        } else {
            #if DEBUG
            print("[\(category.rawValue)] \(message)")
            #endif
        }
    }
    
    /// Log level is error
    /// - Parameters:
    ///   - message: description
    ///   - category: log category
    static func error(message: StaticString, category: Category) {
        if #available(iOS 10.0, *) {
            os_log(message,
                   log: OSLog(subsystem: subsystem,
                              category: category.rawValue),
                   type: .error)
        } else {
            #if DEBUG
            print("[\(category.rawValue)] \(message)")
            #endif
        }
    }
}
