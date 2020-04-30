//
//  ViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/6/1.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let notification = UIApplication.userDidTakeScreenshotNotification
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(afterTakeScreenshot(_:)),
                                               name: notification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: notification,
                                                  object: nil)
    }
    
    @objc private func afterTakeScreenshot(_ notification: Notification) {
        print("AfterTakeScreenshot")
    }
}
