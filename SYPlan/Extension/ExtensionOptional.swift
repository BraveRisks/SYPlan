//
//  ExtensionOptional.swift
//  SYPlan
//
//  Created by Ray on 2020/2/25.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import Foundation

extension Optional {
    
    /// 判斷該型別是否為nil
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
    
    /// 判斷該型別是否不為nil
    var isNotNil: Bool {
        switch self {
        case .none:
            return false
        case .some:
            return true
        }
    }
    
}
