//
//  ExtensionView.swift
//  SYPlan
//
//  Created by Ray on 2018/11/26.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Use for UITest
    @IBInspectable
    var accessibilityId: String? {
        get {
            return accessibilityIdentifier
        }
        
        set {
            isAccessibilityElement = true
            accessibilityIdentifier = newValue
        }
    }
}
