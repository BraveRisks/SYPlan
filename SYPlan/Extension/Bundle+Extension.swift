//
//  ExtensionBundle.swift
//  SYPlan
//
//  Created by Ray on 2019/7/11.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// 取得檔案URL
    /// - Parameters:
    ///   - fileName: 檔案名稱
    ///   - withExtension: 檔案副檔名
    class func url(from fileName: String?, withExtension: String?) -> URL? {
        return Bundle.main.url(forResource: fileName, withExtension: withExtension)
    }
    
    /// 取得UINib
    /// - Parameters:
    ///   - name: Nib 名稱
    ///   - type: 型別
    static func loadNib<T: AnyObject>(with name: String, type: T.Type) -> T? {
        return Bundle(for: type).loadNibNamed(name, owner: type, options: nil)?.first as? T
    }
}
