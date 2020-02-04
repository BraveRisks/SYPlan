//
//  ExtensionColor.swift
//  XPlan
//
//  Created by Ray on 2018/5/25.
//  Copyright © 2018年 Ray. All rights reserved.
//  Swift version：4.1

import UIKit

extension UIColor {
    
    /// let color = UIColor(hex: "ff0000")
    ///
    /// - Parameter hex: 色碼
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    /// let hex = UIColor.red.toHexString
    /// hex = "FF0000"
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    /// 依照系統的模式，動態更改顏色
    static var orangeAccent: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(hex: "ffa366")
                } else {
                    return UIColor(hex: "ff6600")
                }
            }
        } else {
            return UIColor(hex: "ff6600")
        }
    }
}
