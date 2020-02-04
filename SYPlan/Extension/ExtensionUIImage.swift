//
//  ExtensionUIImage.swift
//  SYPlan
//
//  Created by Ray on 2018/8/29.
//  Copyright © 2018年 Sinyi. All rights reserved.
//  Swift version：4.1

import UIKit

extension UIImage {
    
    /// 資料型別
    ///
    /// - jpeg: jpeg
    /// - png: png
    enum DataType {
        
        case jpeg(quality: CGFloat)
        
        case png
    }
    
    /// 調整圖片大小
    /// - Parameter size: you want to size
    func resize(with size: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale

        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = scale
            format.opaque = false
            
            let renderer = UIGraphicsImageRenderer(size: size, format: format)
            return renderer.image { (context) in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            self.draw(in: CGRect(origin: .zero, size: size))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
    }
    
    /// 裁減圖片 reference: https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping
    /// - Parameter rect: 裁減範圍
    func crop(with rect: CGRect) -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        
        guard let cropImage = cgImage.cropping(to: rect) else { return self }
        
        let scale = UIScreen.main.scale
        let image = UIImage(cgImage: cropImage, scale: scale, orientation: .up)
        
//        #if targetEnvironment(simulator)
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        #endif
        
        return image
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
    
    /// 圖片轉Base64 String
    ///
    /// - Parameter: type: See more `DataType`
    ///
    /// - Returns: String?
    func base64Str(from type: DataType) -> String? {
        switch type {
        case .jpeg(let quality):
            let data = self.jpegData(compressionQuality: quality)
            return data?.base64EncodedString(options: [])
        case .png:
            let data = self.pngData()
            return data?.base64EncodedString(options: [])
        }
    }
    
    /// 將圖片旋轉
    /// - Parameter radians: 弧度
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size)
                            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
                            .size
        
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
