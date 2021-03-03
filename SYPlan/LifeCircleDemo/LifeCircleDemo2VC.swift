//
//  LifeCircleDemo2VC.swift
//  SYPlan
//
//  Created by Ray on 2021/2/20.
//  Copyright © 2021 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class LifeCircleDemo2VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LifeCircleDemo2VC viewDidLoad")
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LifeCircleDemo2VC viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("LifeCircleDemo2VC viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("LifeCircleDemo2VC viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("LifeCircleDemo2VC viewDidDisappear")
    }
    
    override func viewDidLayoutSubviews() {
        print("LifeCircleDemo2VC viewDidLayoutSubviews")
    }
    
    private func setup() {
        let btn = UIButton(type: .system)
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self,
                      action: #selector(back(_:)),
                      for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        
        btn.centerXAnchor
           .constraint(equalTo: view.centerXAnchor)
           .isActive = true
        btn.centerYAnchor
           .constraint(equalTo: view.centerYAnchor)
           .isActive = true
    }
    
    @objc private func back(_ btn: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
