//
//  NavigationDemoSwipeController.swift
//  SYPlan
//
//  Created by Ray on 2019/7/5.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit
import Toaster

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
        
        // 是否要有半透明遮罩
        navigationBar.isTranslucent = false
        
        // Reference: https://juejin.im/entry/5795809dd342d30059ed5c60
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
    
    public func getNavigationControllerInfo() {
        // 取得最上層的UIViewController
        if let top = topViewController {
            let toast = Toast(text: "NavigationDemoSwipeController topVC = \(top)",
                              delay: 0.0,
                              duration: Delay.short)
            toast.show()
        }
       
        // 取得目前可見的UIViewController
        if let visible = visibleViewController {
            let toast = Toast(text: "NavigationDemoSwipeController visibleVC = \(visible)",
                              delay: 2.0,
                              duration: Delay.short)
            toast.show()
        }
    }
}

extension NavigationDemoSwipeController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count > 1
    }
}
