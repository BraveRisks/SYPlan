//
//  ShareExtensionViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/8/15.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class ShareExtensionViewController: UIViewController {

    @IBOutlet weak var mImgView: UIImageView!
    @IBOutlet weak var mLab: UILabel!
    
    // 對應到AppGroups
    private let suitName = "group.SinyiSearch"
    private let imageKey = "ImageKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mImgView.contentMode = .scaleAspectFill
        mLab.text = "ShareExtensionViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        // 取得透過Share Extension的資料
        let userDefault = UserDefaults(suiteName: suitName)

        if let dict = userDefault?.value(forKey: imageKey) as? [String: Any] {
            mImgView.image = UIImage(data: dict["imgData"] as! Data)
            let content = dict["content"] as? String ?? ""
            let friend = dict["friend"] as? String ?? ""
            mLab.text = "\(friend) - \(content)"
        } else {
            print("dict is nil.")
        }
    }
}
