//
//  PDFManager.swift
//  SYPlan
//
//  Created by Ray on 2019/4/2.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit

class PDFManager {
    
    /// PDF頁面的大小，大小依據「ISO Paper sizes」設置
    ///
    /// - A4: width: 595.0, height: 842.0
    /// - A5: width: 420.0, height: 595.0
    /// - A6: width: 298.0, height: 420.0
    enum Page {
        /// width: 595.0, height: 842.0
        case A4
        /// width: 420.0, height: 595.0
        case A5
        /// width: 298.0, height: 420.0
        case A6
    }
    
    typealias completion = () -> Swift.Void
    
    static let shared = PDFManager()
    
    /// 密碼最長長度
    private let passwordMaxLen = 32
    
    private init() {}
    
    public func create(from images: [UIImage], dst: URL, password: String, page: Page = .A4,
                       completion: completion?) {
        guard images.count > 0 else {
            completion?()
            return
        }
        
        // 檢查是否可以轉為ASCII
        guard password.canBeConverted(to: String.Encoding.ascii) else {
            completion?()
            return
        }
        
        // 檢查密碼長度是否大於32位
        guard password.count <= passwordMaxLen else {
            completion?()
            return
        }

        UIGraphicsBeginPDFContextToFile(dst.path, .zero, documentInfo(with: password))
        generator(from: images, page: page)
        UIGraphicsEndPDFContext()
        completion?()
    }
    
    public func create(from images: [UIImage], password: String, page: Page = .A4) -> Data? {
        guard images.count > 0 else { return nil }
        
        // 檢查是否可以轉為ASCII
        guard password.canBeConverted(to: String.Encoding.ascii) else { return nil }
        
        // 檢查密碼長度是否大於32位
        guard password.count <= passwordMaxLen else { return nil }
        
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, .zero, documentInfo(with: password))
        generator(from: images, page: page)
        UIGraphicsEndPDFContext()
        return data as Data
    }
    
    private func documentInfo(with password: String) -> [AnyHashable: Any]? {
        guard !password.isEmpty else { return nil }
        // 設置密碼時，下列2個參數需帶入
        // kCGPDFContextUserPassword ; kCGPDFContextOwnerPassword
        let info: [AnyHashable: Any] = [String(kCGPDFContextUserPassword): password,
                                        String(kCGPDFContextOwnerPassword): password]
        return info
    }
    
    private func generator(from images: [UIImage], page: Page) {
        let scale = UIScreen.main.scale
        let rect = rectCreate(from: page)
        
        for image in images {
            autoreleasepool {
                // 取得圖片原始大小
                let width  = image.size.width * scale
                let height = image.size.height * scale
                
                var scaleFactor: CGFloat = 1.0
                if width > rect.size.width {
                    scaleFactor = rect.size.width / width
                }
                
                // 縮放後的圖片大小
                let scaleW = width * scaleFactor
                let scaleH = height * scaleFactor
                
                // 將圖片水平垂直置中
                var offsetX: CGFloat = 0.0
                var offsetY: CGFloat = 0.0
                if rect.size.width > scaleW { offsetX = (rect.size.width - scaleW) / 2 }
                if rect.size.height > scaleH { offsetY = (rect.size.height - scaleH) / 2 }
                let bounds = CGRect(
                    origin: CGPoint(x: offsetX, y: offsetY),
                    size: CGSize(width: scaleW, height: scaleH)
                )
                
                UIGraphicsBeginPDFPageWithInfo(rect, nil)
                image.draw(in: bounds)
            }
        }
    }
    
    private func rectCreate(from page: Page) -> CGRect {
        
        // 下列各紙張尺寸依據「72像素/英寸」，Scale = 1.0 為基準
        // 如果更改為「150像素/英寸」，則Scale = 150 / 72，下列尺寸需乘於Scale
        var rect = CGRect.zero
        switch page {
        case .A4:rect = CGRect(origin: .zero, size: CGSize(width: 595.0, height: 842.0))
        case .A5:rect = CGRect(origin: .zero, size: CGSize(width: 420.0, height: 595.0))
        case .A6:rect = CGRect(origin: .zero, size: CGSize(width: 298.0, height: 420.0))
        }
        return rect
    }
}
