//
//  ExtensionUIImage.swift
//  SYPlan
//
//  Created by Ray on 2018/8/29.
//  Copyright © 2018年 Sinyi. All rights reserved.
//  Swift version：4.1

import UIKit

extension UIImage {
    
    func resize(withWidth width: CGFloat) -> UIImage {
        let scale = width / self.size.width
        let height = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func resize(withHeight height: CGFloat) -> UIImage {
        let scale = height / self.size.height
        let width = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func resize(witScale scale: CGFloat) -> UIImage {
        let width = self.size.width * scale
        let height = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func resizeForScale() -> UIImage {
        var width = self.size.width
        var height = self.size.height
        // 計算長寬的比例
        let scale: CGFloat = width / height
        
        let baseW: CGFloat = 230.0
        let baseH: CGFloat = 230.0
        // example：
        // 1. 6000 * 4000(橫) --> 1.5：1
        // 2. 1333 * 2000(直) --> 0.66：1
        // 3. 1000 * 1000(正) --> 1：1
        // 表示是直式的
        if scale > 1.0 {
            width = baseW
            height = baseW / 1.5
        } else if scale < 1.0 {
            width = baseH * scale
            height = baseH
        } else {
            width = baseW
            height = baseH
        }
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func base64Str(isJPG: Bool = true, quality: CGFloat = 0.8) -> String? {
        if isJPG {
            return self.jpegData(compressionQuality: quality)?.base64EncodedString(options: .lineLength64Characters)
        } else {
            return self.pngData()?.base64EncodedString(options: .lineLength64Characters)
        }        
    }
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2,
                             width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
