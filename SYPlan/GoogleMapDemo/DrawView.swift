//
//  DrawView.swift
//  SYPlan
//
//  Created by Ray on 2020/9/2.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

protocol DrawViewDelegate: class {
    
    func onDrawBegan(_ drawView: DrawView)
    
    func onDrawing(_ drawView: DrawView)
    
    func onDrawEnd(_ drawView: DrawView, points: Array<CGPoint>)
    
}

/// 繪畫View
// Reference:
// 1. https://riptutorial.com/ios/example/13624/designing-and-drawing-a-bezier-path
// 2. https://www.raywenderlich.com/5895-uikit-drawing-tutorial-how-to-make-a-simple-drawing-app
class DrawView: UIView {

    private lazy var path: UIBezierPath = {
        let path = UIBezierPath()
        path.lineWidth = 4
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        return path
    }()
    
    /// 手指移動時的位置，default = []
    private var paths: Array<CGPoint> = []
    
    private var isEnd: Bool = false
    
    /// 是否可以繪製
    var canDraw: Bool = true
    
    weak var delegate: DrawViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard canDraw else { return }
        guard let first = touches.first else { return }
        
        // 清除上一次的繪製點
        if paths.isEmpty == false {
            paths.removeAll()
            path.removeAllPoints()
        }
        
        delegate?.onDrawBegan(self)
        paths.append(first.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard canDraw else { return }
        guard let first = touches.first else { return }
        
        let p = first.location(in: self)
        paths.append(p)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard canDraw else { return }
        guard let first = touches.first else { return }
        
        let p = first.location(in: self)
        paths.append(p)
        
        isEnd = true
        setNeedsDisplay()
        
        delegate?.onDrawEnd(self, points: paths)
    }
    
    override func draw(_ rect: CGRect) {
        guard paths.isEmpty == false else { return }
        
        for i in 0 ..< paths.count {
            if i == 0 { path.move(to: paths[i]) }
            
            path.addLine(to: paths[i])
        }
        
        if isEnd {
            path.close()
        }
        
        UIColor.systemRed.setStroke()
        path.stroke()
    }
}
