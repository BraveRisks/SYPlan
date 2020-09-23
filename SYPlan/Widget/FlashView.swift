//
//  FlashView.swift
//  SYPlan
//
//  Created by Ray on 2020/9/22.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class FlashView: UIView {
    
    private var rectangel: UIView?
    
    private var currentCount: Int = 0
    
    private var originCenter: CGPoint = .zero
    
    private var isStop: Bool = false
    
    /// 動畫重複播放次數，default = 0 (means infinite loop)
    var repeatCount: Int = 0
    
    /// 動畫持續時間，default = 0.55
    var duration: TimeInterval = 0.55
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        let distance = -frame.height / 2
        originCenter = CGPoint(x: distance, y: distance)
        rectangel?.center = originCenter
    }
    
    deinit {
        isStop = true
        print("\(self) deinit.")
    }
    
    private func setup() {
        backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        
        rectangel = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.width, height: 40.0))
        rectangel?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        rectangel?.transform = CGAffineTransform(rotationAngle: 135.0.radians)
        addSubview(rectangel!)
        
        clipsToBounds = true
    }
    
    /// 動畫完成後的動作
    private func finishAction() {
        guard isStop == false else { return }
        
        if repeatCount <= 0 {
            start()
        } else if currentCount < repeatCount {
            start()
        }
    }
    
    public func start() {
        isStop = false
        
        // 當有設定播放次數，才做+1動作
        if repeatCount > 0 { currentCount += 1 }
        
        UIView.animate(withDuration: duration) {
            self.rectangel?.center = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        } completion: { [weak self] (finish) in
            self?.rectangel?.center = self?.originCenter ?? .zero
            self?.finishAction()
        }
    }
    
    public func stop() {
        isStop = true
    }
}
