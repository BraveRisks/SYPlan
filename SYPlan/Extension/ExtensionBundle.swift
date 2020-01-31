//
//  ExtensionBundle.swift
//  SYPlan
//
//  Created by Ray on 2019/7/11.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import Foundation

extension Bundle {
    
    static func load<T: AnyObject>(with name: String, type: T.Type) -> T? {
        // Bundle(for: OOXX.self)
        // Bundle.main
        return Bundle(for: type).loadNibNamed(name, owner: type, options: nil)?.first as? T
    }
}
