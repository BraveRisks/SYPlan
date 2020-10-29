//
//  AttributedStringHelper.swift
//  AnalyticsApp
//
//  Created by Ray on 2018/5/24.
//  Copyright © 2018年 m260user. All rights reserved.
//  Swift version 4.1

import UIKit

/// 幫助使用者快速產生AttributedString
/// ````
/// How to use ?
/// let text = "BMW G02 X4 xDrive30i 美國試駕，邁進跑旅新領域"
///
/// let paragraph = NSMutableParagraphStyle()
/// paragraph.lineSpacing = 2.5
/// paragraph.alignment = .center
///
/// label.attributedText = AttributedStringBuilder(with: text)
///    .withFont(UIFont.boldSystemFont(ofSize: 12.0))
///    .withParagraphStyle(paragraph)
///    .withForegroundColor(.white)
///    .withBackgroundColor(.red)
///    .withKern(2.0)
///    .withUnderlineColor(.black)
///    .withUnderlineStyle(.single)
///    .and(length: 20)
///    .withFont(UIFont.systemFont(ofSize: 16.0))
///    .withForegroundColor(.yellow)
///    .build(form: 21, length: text.count - 21)
/// label.numberOfLines = 0
/// ````
class AttributedStringBuilder: NSObject {
    private var attributes: [NSAttributedString.Key : Any] = [:]
    private var attrStr: NSMutableAttributedString!
    
    private override init() {
        super.init()
    }
    
    convenience init(with text: String) {
        self.init()
        attrStr = NSMutableAttributedString(string: text)
    }
    
    /// 設定字體大小or樣式
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withFont(_ font: UIFont) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.font] = font
        return self
    }
    
    /// 設定字體間距
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withKern(_ kern: CGFloat) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.kern] = kern
        return self
    }
    
    /// 設置字體行距、對齊位置
    /// ````
    /// example:
    /// let paragraph = NSMutableParagraphStyle()
    /// paragraph.lineSpacing = 2.5
    /// paragraph.lineHeightMultiple = 2.0
    /// paragraph.alignment = .center
    /// ````
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withParagraphStyle(_ paragraphStyle: NSMutableParagraphStyle) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        return self
    }
    
    /// 設定字體傾斜角度
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withObliqueness(_ obliqueness: CGFloat) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.obliqueness] = obliqueness
        return self
    }
    
    /// 設定字體扁平化
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withExpansion(_ expansion: CGFloat) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.expansion] = expansion
        return self
    }
    
    /// 設定字體前景色
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withForegroundColor(_ color: UIColor) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.foregroundColor] = color
        return self
    }
    
    /// 設定字體背景色
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.backgroundColor] = color
        return self
    }
    
    /// 設定刪除線顏色
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withStrikethroughColor(_ color: UIColor) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.strikethroughColor] = color
        return self
    }
    
    //// 設定刪除線樣式
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withStrikethroughStyle(_ style: NSUnderlineStyle) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.strikethroughStyle] = style.rawValue
        return self
    }
    
    /// 設定底線顏色
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withUnderlineColor(_ color: UIColor) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.underlineColor] = color
        return self
    }
    
    /// 設定底線樣式
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withUnderlineStyle(_ style: NSUnderlineStyle) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.underlineStyle] = style.rawValue
        return self
    }
    
    /// 設定字體陰影
    /// ````
    /// example:
    /// let s = NSShadow()
    /// s.shadowColor = UIColor.blue
    /// s.shadowOffset = CGSize(width: 1.0, height: 1.0)
    /// shadowBlurRadius --> 顏色擴散的淺度
    /// s.shadowBlurRadius = 0.5
    /// ````
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withShadow(_ shadow: NSShadow) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.shadow] = shadow
        return self
    }
    
    /// 設定字體文字鏈結，只適用在UITextView，並且將屬性設定為isSeleted = true, isEditable = false
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withLink(_ url: URL) -> AttributedStringBuilder {
        attributes[NSAttributedString.Key.link] = url
        return self
    }
    
    /// 設定圖片
    /// - Returns: AttributedStringBuilder
    @discardableResult
    func withImage(_ image: UIImage, bounds: CGRect) -> AttributedStringBuilder {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds
        
        let temp = NSAttributedString(attachment: attachment)
        attrStr.append(temp)
        
        return self
    }
    
    /**
    多重設定，用法請看上述例子
    - Parameters:
        - form:前1個套用的起始位置，Default：0
        - length:前1個套用的長度
    - Returns: AttributedStringBuilder
     */
    @discardableResult
    func and(form: Int = 0, length: Int) -> AttributedStringBuilder {
        let range = NSRange(location: form, length: length)
        attrStr.addAttributes(attributes, range: range)
        attributes.removeAll()
        return self
    }
    
    /**
    - Parameters:
        - form:前1個套用的起始位置，Default：0
        - length:前1個套用的長度
    - Returns: NSMutableAttributedString
     */
    func build(form: Int = 0, length: Int) -> NSMutableAttributedString {
        let range = NSRange(location: form, length: length)
        attrStr.addAttributes(attributes, range: range)
        return attrStr
    }
}

extension String {
    
    var toAttributedString: NSMutableAttributedString { NSMutableAttributedString(string: self) }
}

extension NSMutableAttributedString {
    
    func addWith(font: UIFont, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
    
    func addWith(kern: CGFloat, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.kern, value: kern, range: range)
    }
    
    func addWith(paragraphStyle: NSMutableParagraphStyle, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
    }
    
    func addWith(obliqueness: CGFloat, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.obliqueness, value: obliqueness, range: range)
    }
    
    func addWith(expansion: CGFloat, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.expansion, value: expansion, range: range)
    }
    
    func addWith(foregroundColor color: UIColor, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func addWith(backgroundColor color: UIColor, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
    }
    
    func addWith(strikethroughColor color: UIColor, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: range)
    }
    
    func addWith(strikethroughStyle style: NSUnderlineStyle, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.strikethroughStyle, value: style.rawValue, range: range)
    }
    
    func addWith(underlineColor color: UIColor, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range)
    }
    
    func addWith(underlineStyle style: NSUnderlineStyle, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.underlineStyle, value: style.rawValue, range: range)
    }
    
    func addWith(shadow: NSShadow, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.shadow, value: shadow, range: range)
    }
    
    func addWith(linkURL: URL, range: NSRange) {
        self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: range)
    }
    
    func addWith(attachment: NSTextAttachment) {
        let attrStr = NSAttributedString(attachment: attachment)
        self.append(attrStr)
    }
}
