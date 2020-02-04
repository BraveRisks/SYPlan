//
//  ExtensionDate.swift
//  SYPlan
//
//  Created by Ray on 2019/4/16.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import Foundation

extension Date {
    
    /// 取得當前秒級時間戳 -  10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 取得當前毫秒級時間戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }
}
