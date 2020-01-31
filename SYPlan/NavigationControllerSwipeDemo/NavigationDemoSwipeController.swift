//
//  NavigationDemoSwipeController.swift
//  SYPlan
//
//  Created by Ray on 2019/7/5.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit

class NavigationDemoSwipeController: UINavigationController {

    /// 浮水印 Image，default = nil
    var watermarkImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setup() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.barTintColor = UIColor(hex: "d6374e")
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        
        // Reference:https://juejin.im/entry/5795809dd342d30059ed5c60
        // Support fullscreen swipe back
        let target = interactivePopGestureRecognizer?.delegate
        let targetView = interactivePopGestureRecognizer?.view
        let action = NSSelectorFromString("handleNavigationTransition:")
        
        let pan = UIPanGestureRecognizer(target: target, action: action)
        pan.delegate = self
        targetView?.addGestureRecognizer(pan)
        
        // Disable system
        interactivePopGestureRecognizer?.isEnabled = false
        
        createWatermarkView()
    }
    
    public func createWatermarkView(with userID: String = "384861") {
        // 計算系統的高度
        var sysHeight = UIApplication.shared.statusBarFrame.height
        
        // 導航列高度
        sysHeight += navigationBar.frame.height
        
        let rect = CGRect(origin: .zero,
                          size: CGSize(width: view.frame.width, height: view.frame.height - sysHeight))
        let watermarkView = WatermarkView(frame: rect, userID: userID)
        if let data = UserDefaults.standard.data(forKey: "image"), let image = UIImage(data: data) {
            print("addWatermark has userdefault data size \(data.count)")
            watermarkImage = image
        } else {
            watermarkView.asImage { (image) in
                print("addWatermark wait processing")
                self.watermarkImage = image
                UserDefaults.standard.setValue(image?.pngData(), forKey: "image")
            }
        }
    }
}

extension NavigationDemoSwipeController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count > 1
    }
}
