//
//  IBConstructible.swift
//  SYPlan
//
//  Created by Ray on 2020/2/21.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//  Reference: https://blog.hal.codes/ib-constructible

import UIKit

protocol IBConstructible: AnyObject {
    
    static var nibName: String { get }
    
    static var bundel: Bundle { get }
}

extension IBConstructible {
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static var bundle: Bundle {
        return Bundle(for: Self.self)
    }
}

extension IBConstructible where Self: UIView {
    
    /// Create from Xib
    static var fromNib: Self {
        let xib = UINib(nibName: nibName, bundle: bundle)
        guard let view = xib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Missing view in \(nibName).xib")
        }
        
        return view
    }
}

extension IBConstructible where Self: UIViewController {
    
    /// Create UIViewController from UIStoryboard
    static var fromStoryboard: Self {
        let storyboard = UIStoryboard(name: nibName, bundle: bundle)
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Missing view controller in \(nibName).storyboard")
        }
        
        return vc
    }
}
