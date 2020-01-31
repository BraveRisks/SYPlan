//
//  ImageFilterManager.swift
//  SYPlan
//
//  Created by Ray on 2019/4/16.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit

struct ImageFilterManager {
    
    enum EffectStyle: String {
        /// 低對比度的黑白攝影膠片
        case mono = "CIPhotoEffectMono"
        
        /// 高對比度的黑白攝影膠片
        case noir = "CIPhotoEffectNoir"
        
        /// 原始對比度的黑白攝影膠片
        case tonal = "CIPhotoEffectTonal"
    }
    
    static let shared: ImageFilterManager = ImageFilterManager()
    
    private var cicontext: CIContext
    
    private init() {
        var openGLContext = EAGLContext(api: .openGLES2)
        if let context = EAGLContext(api: .openGLES3) { openGLContext = context }
        EAGLContext.setCurrent(openGLContext)
        cicontext = CIContext(eaglContext: openGLContext!)
    }
    
    /// 灰階效果
    public func grayscale(in ciImage: CIImage, effectStyle style: EffectStyle = .tonal) -> CIImage? {
        let filter = CIFilter(name: style.rawValue)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        return filter?.value(forKey: kCIOutputImageKey) as? CIImage
    }
    
    /// 縮放效果
    public func scale(in ciImage: CIImage, scale s: CGFloat) -> CIImage? {
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(CGAffineTransform(scaleX: s, y: s), forKey: kCIInputTransformKey)
        return filter?.value(forKey: kCIOutputImageKey) as? CIImage
    }
    
    /// 生成UIImage
    public func create(in ciImage: CIImage) -> UIImage? {
        guard let cgimage = cicontext.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgimage)
    }
}
