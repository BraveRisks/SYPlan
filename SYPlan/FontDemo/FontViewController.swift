//
//  FontViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/10/23.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class FontViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .white
        
        let h: CGFloat = 100.0
        
        let mFont1Lab = UILabel()
        mFont1Lab.text = createText("footnote")
        mFont1Lab.numberOfLines = 0
        mFont1Lab.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mFont1Lab)
        NSLayoutConstraint.activate([
            mFont1Lab.topAnchor.constraint(equalTo: view.topAnchor, constant: 64.0),
            mFont1Lab.heightAnchor.constraint(equalToConstant: h),
            mFont1Lab.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0),
            mFont1Lab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5.0)
        ])
        
        // Dynamic font only for iOS 10
        mFont1Lab.font = UIFont.preferredFont(forTextStyle: .footnote)
        if #available(iOS 10.0, *) {
            mFont1Lab.adjustsFontForContentSizeCategory = true
        }
        
        let mFont2Lab = UILabel()
        mFont2Lab.text = createText("Mali-Bold")
        mFont2Lab.numberOfLines = 0
        mFont2Lab.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mFont2Lab)
        NSLayoutConstraint.activate([
            mFont2Lab.topAnchor.constraint(equalTo: mFont1Lab.bottomAnchor, constant: 5.0),
            mFont2Lab.heightAnchor.constraint(equalToConstant: h),
            mFont2Lab.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0),
            mFont2Lab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5.0)
        ])
        
        // Use Custom font
        mFont2Lab.font = UIFont(name: "Mali-Bold", size: 16.0)
        
        let font3 = "NotoSansCJKtc-DemiLight"
        let mFont3Lab = UILabel()
        mFont3Lab.text = createText(font3)
        mFont3Lab.numberOfLines = 0
        mFont3Lab.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mFont3Lab)
        NSLayoutConstraint.activate([
            mFont3Lab.topAnchor.constraint(equalTo: mFont2Lab.bottomAnchor, constant: 5.0),
            mFont3Lab.heightAnchor.constraint(equalToConstant: h),
            mFont3Lab.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0),
            mFont3Lab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5.0)
        ])
        
        // Use Dynamic Custom font only for iOS 11
        if #available(iOS 11.0, *) {
            let fontMetrics = UIFontMetrics(forTextStyle: .headline)
            mFont3Lab.font = fontMetrics.scaledFont(for: UIFont(name: font3, size: 16.0)!)
            mFont3Lab.adjustsFontForContentSizeCategory = true
        }
    }
    
    private func createText(_ fontType: String) -> String {
        return  """
                Font：\(fontType)\nSuzuki New Jimny日本試駕 不愧是超人氣新星！
                """
    }
}
