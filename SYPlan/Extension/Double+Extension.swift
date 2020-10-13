//
//  ExtensionDouble.swift
//  SYPlan
//
//  Created by Ray on 2020/2/4.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

extension Double {
    
    /// 轉成字串
    var string: String {
        return String(self)
    }
    
    /// 角度轉弧度
    var radians: CGFloat {
        return CGFloat(self / 180.0) * CGFloat.pi
    }
    
    /// 取小數點第n位 default roundingMode：.down
    /// ```
    /// How to use：
    /// 10.48989.round(to: 1)  result：10.4
    /// 10.48989.round(to: 2)  result：10.48
    /// 10.48989.round(to: 3)  result：10.489
    /// 10.48989.round(to: 4)  result：10.4898
    /// ```
    /// - Parameters:
    ///   - n: 取小數點第幾位
    ///   - roundingMode: .down(無條件捨去), .up(無條件進位), .plain(4捨5入), .bankers
    /// - Returns: double
    func round(to n: Int, roundingMode: NSDecimalNumber.RoundingMode = .down) -> Double {
        var result = Decimal()
        var value = Decimal(self)
        NSDecimalRound(&result, &value, n, roundingMode)
        return NSDecimalNumber(decimal: result).doubleValue
    }
}
