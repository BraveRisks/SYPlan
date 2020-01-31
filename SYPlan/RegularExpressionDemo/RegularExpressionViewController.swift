//
//  RegularExpressionViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/7/26.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class RegularExpressionViewController: UIViewController {
    
    private var mLab: UILabel?
    
    private var isRegularExpression1: Bool = true
    private var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                            target: self,
                                                            action: #selector(refresh(_:)))
        view.backgroundColor = .black
        
        mLab = UILabel()
        mLab?.numberOfLines = 0
        mLab?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mLab!)
        
        mLab?.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0).isActive = true
        mLab?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0).isActive = true
        mLab?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0).isActive = true
        
        text = "隨著 Intel 發表最新的第八代 Core i9 六核心處理器後，各家筆電廠商開始推出搭載全新處理器的電競筆電新品，包含先前測試過的 Acer Predator Helios 500，ASUS 推出的 ROG G703GI、AORUS  的 X9 DT，以及 MSI 發表的 GT75 Titan 8RG都紛紛換上最新處理器。為了讓各位能夠一次瞭解四款全新的電競筆電，因此有了這篇專題文章的誕生。要先向大家說明的是這四款最新的電競筆電雖然都內建 Intel Core i9 處理器，不過在硬體規格配置上還是有些微差異，小編在文章中就不特別進行比較，當然也會彙整表格讓各位參考，也更加清楚自己的使用需求。文章一開始先為各位奉上本次測試的四款電競筆電規格，並在表格下方放上目前各產品的建議售價，以官方提供的規格來看，Acer Predator Helios 500 算是規格較不優的一款，包含記憶體、顯示卡部分都與其它三款筆電有所差異。以性價比來看，是以 MSI GT75 Titan 8RG 這款電競筆電較占優勢，先提供給各位有個初步的參考。👉🏻 JJJjjj "
        setupRegularExpression1(text)
    }
    
    private func setupRegularExpression1(_ text: String) {
        // matches --> 找的匹配的字元
        let attrStr = text.toAttributedString
        attrStr.addWith(foregroundColor: .white, range: NSRange(location: 0, length: attrStr.length))
        
        let font = UIFont.systemFont(ofSize: 16.0)
        attrStr.addWith(font: font, range: NSRange(location: 0, length: attrStr.length))
        /*
         NSRegularExpression.Options
           caseInsensitive：           不區分大寫
           allowCommentsAndWhitespace：忽略空白以及開頭是#的符號
           ignoreMetacharacters：      忽略元字符
           dotMatchesLineSeparators：  允許匹配任意字符，包括換行
           anchorsMatchLines：         允許^和$匹配多行文本的開始和結尾
           useUnixLineSeparators：     使用Unix行分隔符
           useUnicodeWordBoundaries：  unkonw
         */
        let regex = try! NSRegularExpression(pattern: "電.{3}", options: .caseInsensitive)
        let matches = regex.matches(in: text,
                                    options: .withTransparentBounds,
                                    range: NSRange(location: 0, length: text.count))
        for result in matches {
            print("Result --> \(result.range.location) - \(result.range.length)")
            attrStr.addWith(foregroundColor: .black, range: result.range)
            attrStr.addWith(backgroundColor: .yellow, range: result.range)
        }
        
        // 在文字尾部加入icon
        let capHeight = font.capHeight
        let imageHeight = CGFloat(30.0)
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "ic_mail")
        
        // 律定圖片的位置大小
        attachment.bounds = CGRect(x: 0.0, y: -(imageHeight - capHeight) / 2, width: 36.0, height: 30.0)
        attrStr.addWith(attachment: attachment)
        
        mLab?.attributedText = attrStr
    }
    
    private func setupRegularExpression2(_ text: String) {
        var regex = try! NSRegularExpression(pattern: "Acer", options: .ignoreMetacharacters)
        
        // stringByReplacingMatches --> 取代字元
        let afterText = regex.stringByReplacingMatches(in: text, options: .withTransparentBounds,
                                                       range: NSRange(location: 0, length: text.count),
                                                       withTemplate: "ASUS")
        
        let attrStr = afterText.toAttributedString
        regex = try! NSRegularExpression(pattern: "ASUS", options: .caseInsensitive)
        let matches = regex.matches(in: afterText,
                                    options: .withTransparentBounds,
                                    range: NSRange(location: 0, length: afterText.count))
        for result in matches {
            print("Result --> \(result.range.location) - \(result.range.length)")
            attrStr.addWith(foregroundColor: .white, range: result.range)
            attrStr.addWith(backgroundColor: .red, range: result.range)
        }
        
        mLab?.attributedText = attrStr
    }
    
    @objc private func refresh(_ barButton: UIBarButtonItem) {
        if isRegularExpression1 {
            setupRegularExpression2(text)
        } else {
            setupRegularExpression1(text)
        }
        
        view.backgroundColor = isRegularExpression1 ? .white: .black
        
        isRegularExpression1.toggle()
    }
}
