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
    
    /// 依照UIView的位置，找到UIViewController
    /// - Returns: UIViewController maybe nil.
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

// MARK: shadow、corner
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

// MARK: Auto layout
extension UIView {
    
    /// Auto layout of top anchor
    /// - Parameters:
    ///   - anchor: see more NSLayoutAnchor
    ///   - constant: 偏移距離，default = 0.0
    /// - Returns: NSLayoutConstraint
    public func topAnchorEqual(to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                               constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return topAnchor.constraint(equalTo: anchor, constant: constant)
    }
    
    /// Auto layout of bottom anchor
    /// - Parameters:
    ///   - anchor: see more NSLayoutAnchor
    ///   - constant: 偏移距離，default = 0.0
    /// - Returns: NSLayoutConstraint
    public func bottomAnchorEqual(to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                                  constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return bottomAnchor.constraint(equalTo: anchor, constant: constant)
    }
    
    /// Auto layout of leading anchor
    /// - Parameters:
    ///   - anchor: see more NSLayoutAnchor
    ///   - constant: 偏移距離，default = 0.0
    /// - Returns: NSLayoutConstraint
    public func leadingAnchorEqual(to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                                   constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return leadingAnchor.constraint(equalTo: anchor, constant: constant)
    }
    
    /// Auto layout of trailing anchor
    /// - Parameters:
    ///   - anchor: see more NSLayoutAnchor
    ///   - constant: 偏移距離，default = 0.0
    public func trailingAnchorEqual(to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                                    constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return trailingAnchor.constraint(equalTo: anchor, constant: constant)
    }

    /// Auto layout of height anchor
    /// - Parameters:
    ///   - anchor: see more NSLayoutDimension
    ///   - constant: 偏移距離，default = 0.0
    /// - Returns: NSLayoutConstraint
    public func heightAnchorEqual(to anchor: NSLayoutDimension,
                                  constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return heightAnchor.constraint(equalTo: anchor, constant: constant)
    }
    
    /// Auto layout of height anchor
    /// - Parameter constant: 偏移距離，default = 0.0
    /// - Returns: NSLayoutConstraint
    public func heightAnchorEqual(constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return heightAnchor.constraint(equalToConstant: constant)
    }
    
    /// Auto layout of width anchor
    /// - Parameters:
    ///   - anchor: see more NSLayoutDimension
    ///   - constant: 偏移距離，default = 0.0
    /// - Returns: NSLayoutConstraint
    public func widthAnchorEqual(to anchor: NSLayoutDimension,
                                  constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return widthAnchor.constraint(equalTo: anchor, constant: constant)
    }
}
