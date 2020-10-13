//
//  Data+Extension.swift
//  SYPlan
//
//  Created by Ray on 2020/10/12.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import Foundation

extension Data {
    
    /// Data轉成文字
    var string: String? {
        get { return String(data: self, encoding: .utf8) }
    }
    
    /// Data轉成Dictionary
    var dictionary: Dictionary<String, Any>? {
        get {
            if let obj = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
                let json = obj as? Dictionary<String, Any> {
                return json
            }
            return nil
        }
    }
}
