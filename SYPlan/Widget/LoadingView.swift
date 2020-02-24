//
//  LoadingView.swift
//  SYPlan
//
//  Created by Ray on 2019/8/12.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    private var indicatorView: UIView?
    
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(hex: "f09d8f")
        
        indicatorView = UIView()
        indicatorView?.backgroundColor = UIColor(hex: "e44d32")
        indicatorView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView!)
        
        indicatorView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indicatorView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        indicatorView?.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        let widthConstraint = indicatorView?.widthAnchor.constraint(equalToConstant: 0.0)
        widthConstraint?.priority = .init(999)
        widthConstraint?.isActive = true
    }
    
    public func startAnimating() {
        if timer == nil {
            timer = Timer(timeInterval: 1, target: self, selector: #selector(startTimer(_:)),
                          userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    public func stopAnimation() {
        timer?.invalidate()
        timer = nil
        
        indicatorView?.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.25, delay: 1.0, options: [.curveEaseInOut], animations: {
            self.backgroundColor = .clear
        }, completion: nil)
    }
    
    @objc private func startTimer(_ timer: Timer) {
        backgroundColor = UIColor(hex: "f09d8f")
        
        indicatorView?.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: frame.height)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.indicatorView?.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.indicatorView?.frame = CGRect(x: self.frame.width, y: 0.0, width: self.frame.width, height: self.frame.height)
            }, completion: nil)
        }
    }
}
