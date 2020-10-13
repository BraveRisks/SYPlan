//
//  ExtensionCGFloat.swift
//  SYPlan
//
//  Created by Ray on 2018/11/16.
//  Copyright © 2018年 Sinyi. All rights reserved.
//  Swift version：4.1

import UIKit

extension CGFloat {
    
    /// 轉換為NSNumber
    var nsNumber: NSNumber {
        return self as NSNumber
    }
    
    /// 角度轉換為弧度
    func radians() -> CGFloat {
        return self * .pi / 180.0
    }
}
