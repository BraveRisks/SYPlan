//
//  StringSizeCacheHelper.swift
//  SYPlan
//
//  Created by Ray on 2020/4/8.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

/// 緩存字串寬度高度的幫助管理員
/// ```
/// How to use it ?
///
/// let helper = StringSizeCacheHelper.share
/// let font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
/// let demo = "😀📢👾👨🏼‍🏫⚠️🤪❇️📢🤡🤡🔥🙇🏻‍♂️🌀"
/// let demoW = demo.width(maxHeight: 40.0, font: font)
/// let demoH = demo.height(maxWidth: 244, font: font)
///
/// helper.put(string: demo, mode: .width(value: demoW))
/// helper.put(string: demo, mode: .height(value: demoH))
/// helper.get(mode: .width(string: demo))
/// helper.get(mode: .height(string: demo))
/// ```
class StringSizeCacheHelper {
    
    enum PutMode {
        
        case width(value: CGFloat)
        
        case height(value: CGFloat)
    }
    
    enum GetMode {
        
        case width(string: String)
        
        case height(string: String)
    }
    
    static let share = StringSizeCacheHelper()
    
    private var cacheW: NSCache<NSString, NSNumber>
    private var cacheH: NSCache<NSString, NSNumber>
    
    private init() {
        cacheW = NSCache()
        cacheW.countLimit = .max
        
        cacheH = NSCache()
        cacheH.countLimit = .max
    }
    
    public func put(string: String, mode: PutMode) {
        switch mode {
        case .width(let value):
            cacheW.setObject(value.nsNumber, forKey: string.nsString)
        case .height(let value):
            cacheH.setObject(value.nsNumber, forKey: string.nsString)
        }
    }
    
    public func get(mode: GetMode) -> CGFloat {
        switch mode {
        case .width(let string):
            return CGFloat(truncating: cacheW.object(forKey: string.nsString) ?? 0.0)
        case .height(let string):
            return CGFloat(truncating: cacheH.object(forKey: string.nsString) ?? 0.0)
        }
    }
    
    public func clear() {
        cacheW.removeAllObjects()
        cacheH.removeAllObjects()
    }
}
