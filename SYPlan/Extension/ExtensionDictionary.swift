//
//  ExtensionDictionary.swift
//  SYPlan
//
//  Created by Ray on 2019/5/3.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// 將Dictionary轉成Data
    var data: Data? {
        get { return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) }
    }
    
    /// 將Dictionary轉成String
    var string: String {
        get {
            guard let data = self.data else { return "" }
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
}

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
