//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Ray on 2018/10/26.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    private let screenW = UIScreen.main.bounds.width
    
    @IBOutlet weak var mImgView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        if notification.request.content.attachments.count > 0 {
            if let data = try? Data(contentsOf: notification.request.content.attachments[0].url, options: .mappedIfSafe),
                var image = UIImage(data: data) {
                // 計算縮放比例
                image = resize(with: image)
                mImgView?.image = image
                let size = CGSize(width: image.size.width, height: image.size.height)
                mImgView?.frame.size = size
                // 重新律定viewcontroller視圖大小
                preferredContentSize = CGSize(width: screenW, height: size.height)
                // 計算偏移位置
                if size.height > size.width {
                    let x = (screenW - size.width) / 2
                    mImgView?.frame.origin = CGPoint(x: x, y: 0.0)
                }
            }
        }
    }
    
    private func resize(with image: UIImage) -> UIImage {
        var width = image.size.width
        var height = image.size.height
        var scale: CGFloat = 1.0
        
        // 計算長寬的比例
        if width > height {
            scale = screenW / width
        } else if height > width {
            scale = 270.0 / height
        }
        
        width *= scale
        height *= scale
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
