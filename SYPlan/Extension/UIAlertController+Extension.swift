//
//  ExtensionUIAlertController.swift
//  SYPlan
//
//  Created by Ray on 2020/7/13.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /// Cancel Action
    typealias CancelAction = (_ action: UIAlertAction) -> Swift.Void
    
    /// Default Action
    typealias DefaultAction = (_ action: UIAlertAction) -> Swift.Void
    
    /// UIAlertController have default and cancel action.
    /// - Parameters:
    ///   - title: 標題
    ///   - message: 訊息
    ///   - defaultText: Default action 標題
    ///   - default: Action, it's can be nil.
    ///   - cancelText: Cancel action 標題
    ///   - cancel: Cancel, default is nil.
    /// - Returns: UIAlertController
    static func defaultAlert(title: String?,
                             message: String?,
                             defaultText: String,
                             default: DefaultAction?,
                             cancelText: String,
                             cancel: CancelAction? = nil) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: defaultText, style: .default, handler: { (action) in
            if `default` != nil { `default`?(action) }
        }))
        
        ac.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { (action) in
            if cancel != nil { cancel?(action) }
        }))
        
        return ac
    }
    
    /// UIAlertController only cancel action.
    /// - Parameters:
    ///   - title: 標題
    ///   - message: 訊息
    ///   - cancelText: Cancel action 標題
    ///   - cancel: Cancel, default is nil.
    /// - Returns: UIAlertController
    static func cancelAlert(title: String?,
                            message: String?,
                            cancelText: String,
                            cancel: CancelAction? = nil) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: { (action) in
            if cancel != nil { cancel?(action) }
        }))
        
        return ac
    }
    
}
