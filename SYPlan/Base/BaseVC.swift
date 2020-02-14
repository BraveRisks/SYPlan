//
//  BaseVC.swift
//  SYPlan
//
//  Created by Ray on 2020/2/4.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    public lazy var backItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "ic_arrow_right"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(back(_:)))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc open func back(_ barButton: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
