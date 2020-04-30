//
//  ScanBorderView.swift
//  SYPlan
//
//  Created by Ray on 2019/7/23.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit

class ScanBorderView: UIView {
    
    enum Style {
        
        /// 小尺寸：225 * 225
        case small
        
        /// 正常尺寸：250 * 250
        case normal
        
        /// 大尺寸：275 * 275
        case large
        
        /// 自定義尺寸
        case customer(size: CGSize)
        
        var size: CGSize {
            switch self {
            case .small: return CGSize(width: 225.0, height: 225.0)
            case .normal: return CGSize(width: 250.0, height: 250.0)
            case .large: return CGSize(width: 275.0, height: 275.0)
            case .customer(let size): return size
            }
        }
    }
    
    /// 邊框的尺寸，default = .normal
    var style: Style = .normal
    
    /// 邊框繪製範圍
    var borderFrame: CGRect = .zero {
        didSet { setNeedsDisplay() }
    }
    
    /// 邊框顏色，default = .red
    var rectBorderColor: UIColor = .red {
        didSet { setNeedsDisplay() }
    }
    
    /// 邊框長度，default = 20.0
    var rectBorderLength: CGFloat = 20.0 {
        didSet { setNeedsDisplay() }
    }
    
    /// 邊框框度，default = 6.0
    var rectBorderWidth: CGFloat = 6.0 {
        didSet { setNeedsDisplay() }
    }
    
    /// 繪製邊框範圍底線，default = false
    var isDrawRect: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    /// 邊框範圍底線顏色，default = .white
    var rectColor: UIColor = UIColor.white {
        didSet { setNeedsDisplay() }
    }
    
    /// 邊框範圍底線寬度，default = 1.2
    var rectWidth: CGFloat = 1.2 {
        didSet { setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let size = style.size
        // 律定Border繪製範圍
        let point = CGPoint(x: rect.midX - (size.width / 2), y: rect.midY - (size.height / 2))
        borderFrame = CGRect(origin: point, size: size)
        
        // 繪製黑色半透明背景
        // left
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var w: CGFloat = (rect.width - borderFrame.width) / 2
        var h: CGFloat = rect.height

        let pathLeft = UIBezierPath(rect: CGRect(x: x, y: y, width: w, height: h))
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75).setFill()
        pathLeft.fill()
        
        // top
        x = w
        w = borderFrame.width
        h = borderFrame.minY

        let pathTop = UIBezierPath(rect: CGRect(x: x, y: y, width: w, height: h))
        pathTop.fill()

        // right
        x = borderFrame.maxX
        w = (rect.width - borderFrame.width) / 2
        h = rect.height

        let pathRight = UIBezierPath(rect: CGRect(x: x, y: y, width: w, height: h))
        pathRight.fill()

        // bottom
        x = w
        y = borderFrame.maxY
        w = borderFrame.width
        h = rect.height - y

        let pathBottom = UIBezierPath(rect: CGRect(x: x, y: y, width: w, height: h))
        pathBottom.fill()
        
        // 律定繪製區域，也就是只能在這區域繪製
        let clipPath = UIBezierPath(rect: borderFrame)
        clipPath.addClip()
        
        // 是否要繪製底層邊框
        if isDrawRect {
            let rectPath = UIBezierPath(rect: borderFrame)
            rectPath.lineWidth = rectWidth
            rectColor.setStroke()
            rectPath.stroke()
        }
        
        // 起始點是依rect的x y軸,所律定
        let oriSX = borderFrame.minX
        let oriSY = borderFrame.minY
        let oriEX = borderFrame.maxX
        let oriEY = borderFrame.maxY
        let borderPath = UIBezierPath()
        borderPath.lineWidth = rectBorderWidth
        borderPath.lineJoinStyle = .miter
        
        // 左上
        borderPath.move(to: CGPoint(x: oriSX, y: oriSY + rectBorderLength))
        borderPath.addLine(to: CGPoint(x: oriSX, y: oriSY))
        borderPath.addLine(to: CGPoint(x: oriSX + rectBorderLength, y: oriSY))
        // 右上
        borderPath.move(to: CGPoint(x: oriEX - rectBorderLength, y: oriSY))
        borderPath.addLine(to: CGPoint(x: oriEX, y: oriSY))
        borderPath.addLine(to: CGPoint(x: oriEX, y: oriSY + rectBorderLength))
        // 左下
        borderPath.move(to: CGPoint(x: oriSX, y: oriEY - rectBorderLength))
        borderPath.addLine(to: CGPoint(x: oriSX, y: oriEY))
        borderPath.addLine(to: CGPoint(x: oriSX + rectBorderLength, y: oriEY))
        // 右下
        borderPath.move(to: CGPoint(x: oriEX, y: oriEY - rectBorderLength))
        borderPath.addLine(to: CGPoint(x: oriEX, y: oriEY))
        borderPath.addLine(to: CGPoint(x: oriEX - rectBorderLength, y: oriEY))
        
        rectBorderColor.setStroke()
        borderPath.stroke()
    }
}
