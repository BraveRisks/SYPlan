//
//  DarkModeVC.swift
//  SYPlan
//
//  Created by Ray on 2019/11/11.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class DarkModeVC: UIViewController {

    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        if #available(iOS 13.0, *) {
            let tintColor = UIColor(hex: "E44D32")
            
            segmentedCtrl.layer.borderColor = tintColor.cgColor
            segmentedCtrl.layer.borderWidth = 1.0
            
            var renderer = UIGraphicsImageRenderer(size: CGSize(width: 100.0, height: 32.0))

            // 選到時的背景色
            var image = renderer.image { context in
                tintColor.setFill()
                context.fill(context.format.bounds)
            }
            segmentedCtrl.setBackgroundImage(image, for: .selected, barMetrics: .default)
            
            // 選到時的字體顏色
            var attrs = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .regular)
            ]
            segmentedCtrl.setTitleTextAttributes(attrs, for: .selected)
            
            // 未選到時的背景色
            image = renderer.image { context in
                UIColor.white.setFill()
                context.fill(context.format.bounds)
            }
            segmentedCtrl.setBackgroundImage(image, for: .normal, barMetrics: .default)
            
            // 未選到時的字體顏色
            attrs = [
                .foregroundColor: tintColor,
                .font: UIFont.systemFont(ofSize: 17.0, weight: .regular)
            ]
            segmentedCtrl.setTitleTextAttributes(attrs, for: .normal)
            
            // 設定中間分隔線顏色
            renderer = UIGraphicsImageRenderer(size: CGSize(width: 1.0, height: 32.0))
            image = renderer.image { context in
                tintColor.setFill()
                context.fill(context.format.bounds)
            }
            
            segmentedCtrl.setDividerImage(image,
                                          forLeftSegmentState: .normal,
                                          rightSegmentState: .normal,
                                          barMetrics: .default)
        } else {
            segmentedCtrl.tintColor = UIColor(hex: "E44D32")
            segmentedCtrl.backgroundColor = .white
            
            let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .regular)]
            segmentedCtrl.setTitleTextAttributes(attrs, for: .normal)
        }
        
        label.textColor = .orangeAccent
        //label.text = "注意字體顏色的變化"
    }
}
