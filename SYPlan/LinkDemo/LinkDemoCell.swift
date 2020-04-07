//
//  LinkDemoCell.swift
//  SYPlan
//
//  Created by Ray on 2020/3/20.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

protocol LinkDemoCellDelegate: class {
    func didClickedURL(cell: LinkDemoCell, url: URL)
}

class LinkDemoCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    var mode: LinkDemoVC.Mode = .dataDetectorTypes(link: "") {
        didSet { setData() }
    }
    
    weak var delegate: LinkDemoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isSelectable = true
    }
    
    private func setData() {
        switch mode {
        case .dataDetectorTypes(let link):
            textView.text = link
            textView.dataDetectorTypes = .link // .all
        case .delegate(let link):
            textView.text = link
            textView.dataDetectorTypes = .link
            textView.delegate = self
        case .nsAttributedString(let link):
            let ary = link.components(separatedBy: ";")
            let normal = ary[0]
            let linkText = ary[1].components(separatedBy: "#")[0]
            let linkURL = ary[1].components(separatedBy: "#")[1]
            let totalLen = (normal + linkText).count
            let url = URL(string: linkURL)!

            textView.attributedText = AttributedStringBuilder(with: normal + linkText)
                .withFont(UIFont.boldSystemFont(ofSize: 14.0))
                .and(length: totalLen)
                .withLink(url)
                .withUnderlineStyle(.single)
                .build(form: normal.count, length: linkText.count)
            
            // 修改LinkText的樣式
            textView.linkTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(hex: "ff0000")
            ]
            
            textView.delegate = self
        }
    }
}

extension LinkDemoCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        // Maybe like https://www.mobile01.com/category.php?id=6
        print("URL = \(URL)")
        
        if URL.absoluteString == "https://www.mobile01.com/category.php?id=6" ||
            URL.absoluteString == "https://dart.dev/guides/language/language-tour#a-basic-dart-program" {
            return true
        }
        
        delegate?.didClickedURL(cell: self, url: URL)
        
        // true: 由系統開啟對應的畫面, false: 自行處理所需的動作
        return false
    }
}
