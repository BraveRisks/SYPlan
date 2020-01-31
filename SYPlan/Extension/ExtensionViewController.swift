//
//  ExtensionViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/9/11.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// 添加浮水印
    /// When you use it, must be on `last` line in onViewDidLoad() method.
    func addWatermark() {
        if let navc = navigationController as? NavigationDemoSwipeController,
            let lastView = self.view.subviews.last {
            
            if let image = navc.watermarkImage {
                print("addWatermark has create")
                
                let imageView = UIImageView(image: image)
                self.view.insertSubview(imageView, aboveSubview: lastView)
            } else {
                print("addWatermark not create")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    let imageView = UIImageView(image: navc.watermarkImage)
                    self.view.insertSubview(imageView, aboveSubview: lastView)
                }
            }
        }
    }
    
    /// 重新產生浮水印
    func refreshWatermark(with userID: String) {
        if let navc = navigationController as? NavigationDemoSwipeController {
            // Remove old image
            UserDefaults.standard.removeObject(forKey: "image")
            navc.createWatermarkView(with: userID)
            
            // Remove watermark view
            self.view.subviews.last?.removeFromSuperview()
            
            navc.watermarkImage = nil
            addWatermark()
        }
    }
}
