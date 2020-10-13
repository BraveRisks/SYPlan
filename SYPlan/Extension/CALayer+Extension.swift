//
//  ExtensionLayer.swift
//  SYPlan
//
//  Created by Ray on 2018/10/29.
//  Copyright © 2018年 Sinyi. All rights reserved.
//  Swift version：4.1

import UIKit

extension CAGradientLayer {
    
    enum Direction: Int {
        case topToBottm = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
        case leftTopToRightBottom
        case rightTopToLeftBottom
        case leftBottomToRightTop
        case rightBottomToLeftTop
        
        var point: (start: CGPoint, end: CGPoint) {
            var sp = CGPoint.zero
            var ep = CGPoint.zero
            switch self {
            case .topToBottm:
                sp = CGPoint(x: 0.5, y: 0.0)
                ep = CGPoint(x: 0.5, y: 1.0)
            case .bottomToTop:
                sp = CGPoint(x: 0.5, y: 1.0)
                ep = CGPoint(x: 0.5, y: 0.0)
            case .leftToRight:
                sp = CGPoint(x: 0.0, y: 0.5)
                ep = CGPoint(x: 1.0, y: 0.6)
            case .rightToLeft:
                sp = CGPoint(x: 1.0, y: 0.5)
                ep = CGPoint(x: 0.0, y: 0.6)
            case .leftTopToRightBottom:
                sp = CGPoint(x: 0.0, y: 0.0)
                ep = CGPoint(x: 1.0, y: 1.0)
            case .rightTopToLeftBottom:
                sp = CGPoint(x: 1.0, y: 0.0)
                ep = CGPoint(x: 0.0, y: 1.0)
            case .leftBottomToRightTop:
                sp = CGPoint(x: 0.0, y: 1.0)
                ep = CGPoint(x: 1.0, y: 0.0)
            case .rightBottomToLeftTop:
                sp = CGPoint(x: 1.0, y: 1.0)
                ep = CGPoint(x: 0.0, y: 0.0)
            }
            return (sp, ep)
        }
    }
    
    /// 產生漸層Layer
    ///
    /// - Parameters:
    ///   - direction: see more
    ///   - startColor: color
    ///   - endColor: color
    ///   - bounds: view of bounds
    ///
    /// ```
    /// let gradient = CAGradientLayer()
    /// gradient.create(direction: .leftTopToRightBottom, startColor: .red, endColor: .white,
    ///                 bounds: view.bounds)
    /// view.layer.insertSublayer(gradient, at: 0)
    /// view.layer.cornerRadius = 8.0
    /// view.layer.masksToBounds = true
    /// ```
    func create(direction: Direction, startColor: UIColor, endColor: UIColor, bounds: CGRect) {
        self.colors = [startColor.cgColor, endColor.cgColor]
        self.locations = [0.0, 1.0]
        self.startPoint = direction.point.start
        self.endPoint = direction.point.end
        self.frame = bounds
    }
}
