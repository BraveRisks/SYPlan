//
//  CADisplayLinkDemoViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/7/10.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit

class CADisplayLinkDemoViewController: UIViewController {

    @IBOutlet weak var animationLabel: UIAnimationLabel!
    @IBOutlet weak var randomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        randomButton.addTarget(self, action: #selector(random(_:)), for: .touchUpInside)
    }
    
    @objc private func random(_ btn: UIButton) {
        let r = Int.random(in: 100 ... 1000)
        animationLabel.animate(from: 20, to: r)
    }
}
