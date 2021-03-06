//
//  ExtensionString.swift
//  SYPlan
//
//  Created by Ray on 2018/12/17.
//  Copyright © 2018 Sinyi. All rights reserved.
//

import UIKit

extension String {
    
    /// 轉換為NSString
    var nsString: NSString { self as NSString }
    
    /// 檢查是否為有效的台灣手機格式
    var isValidPhone: Bool {
        let pattern = "09\\d{8}$|\\+?8869\\d{8}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regex.matches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: self.count))
        return matches.count > 0
    }
    
    /// 檢查是否為有效的Email格式
    var isValidEmail: Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regex.matches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: self.count))
        return matches.count > 0
    }
    
    /// 檢查輸入字串中有包含「號」
    var hasAddressNo: Bool {
        let pattern = ".*號.*"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regex.matches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: self.count))
        return matches.count > 0
    }
    
    /// 將string轉成Dictionary<String, Any>
    var dictionary: Dictionary<String, Any> {
        guard let data = self.data(using: .utf8) else { return [:] }
        let any = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return any as? Dictionary<String, Any> ?? [:]
    }
    
    /// 計算文字的高度
    ///
    /// - Parameters:
    ///   - maxWidth: 限制寬度的大小
    ///   - font: 字型的樣式
    /// - Returns: 計算後的高度
    func height(maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let attrString = NSMutableAttributedString(string: self)
        attrString.addAttribute(.font, value: font, range: NSRange(location: 0, length: self.utf16.count))
        let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = attrString.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            context: nil)
        return ceil(boundingBox.height)
    }
    
    /// 計算文字的寬度
    ///
    /// - Parameters:
    ///   - maxHeight: 限制高度的大小
    ///   - font: 字型的樣式
    /// - Returns: 計算後的寬度
    func width(maxHeight: CGFloat, font: UIFont) -> CGFloat {
        let attrString = NSMutableAttributedString(string: self)
        attrString.addAttribute(.font, value: font, range: NSRange(location: 0, length: self.utf16.count))
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
        let boundingBox = attrString.boundingRect(with: constraintRect,
                                                  options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                  context: nil)
        return ceil(boundingBox.width)
    }
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    func hexadecimal() -> Data? {
        var data = Data(capacity: self.count / 2)
        
        guard let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}",
                                                   options: .caseInsensitive)
        else {
            return nil
        }
        
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count))
        { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
}
