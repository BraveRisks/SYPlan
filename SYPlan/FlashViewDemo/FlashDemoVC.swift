//
//  FlashDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2020/9/22.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

/// 仿CSS的效果(第四個)
/// Reference: https://codepen.io/davidicus/pen/emgQKJ
class FlashDemoVC: UIViewController {

    private var flashView: FlashView!
    private var hStackView_1: UIStackView!
    private var hStackView_2: UIStackView!
    private var hStackView_3: UIStackView!
    private var hStackView_4: UIStackView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        // 閃爍 View
        flashView = FlashView()
        flashView.repeatCount = 0
        flashView.cornerRadius = 8.0
        flashView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flashView)
        
        // 設定背景色
        let label1 = UILabel()
        label1.text = "背景色："
        label1.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        let segmentedCtrl1 = UISegmentedControl(items: ["淺灰色", "淺藍色", "淺紅色"])
        segmentedCtrl1.selectedSegmentIndex = 0
        segmentedCtrl1.addTarget(self,
                                 action: #selector(switchColor(_:)),
                                 for: .valueChanged)
        
        hStackView_1 = UIStackView()
        hStackView_1.axis = .horizontal
        hStackView_1.spacing = 0.0
        hStackView_1.addArrangedSubview(label1)
        hStackView_1.addArrangedSubview(segmentedCtrl1)
        hStackView_1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hStackView_1)
        
        // 動畫時間
        let label2 = UILabel()
        label2.text = "動畫時間："
        label2.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        let segmentedCtrl2 = UISegmentedControl(items: ["0.55s", "2s", "4s", "6s"])
        segmentedCtrl2.selectedSegmentIndex = 0
        segmentedCtrl2.addTarget(self,
                                 action: #selector(switchDuration(_:)),
                                 for: .valueChanged)
        
        hStackView_2 = UIStackView()
        hStackView_2.axis = .horizontal
        hStackView_2.spacing = 0.0
        hStackView_2.addArrangedSubview(label2)
        hStackView_2.addArrangedSubview(segmentedCtrl2)
        hStackView_2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hStackView_2)
        
        // AutoLayout
        flashView.topAnchor
                 .constraint(equalTo: view.topAnchor, constant: 40.0)
                 .isActive = true
        flashView.leadingAnchor
                 .constraint(equalTo: view.leadingAnchor, constant: 20.0)
                 .isActive = true
        flashView.trailingAnchor
                 .constraint(equalTo: view.trailingAnchor, constant: -20.0)
                 .isActive = true
        flashView.heightAnchorEqual(constant: 40.0)
                 .isActive = true
        
        hStackView_1.topAnchor
                    .constraint(equalTo: flashView.bottomAnchor, constant: 28.0)
                    .isActive = true
        hStackView_1.centerXAnchor
                    .constraint(equalTo: flashView.centerXAnchor)
                    .isActive = true
        
        hStackView_2.topAnchor
                    .constraint(equalTo: hStackView_1.bottomAnchor, constant: 16.0)
                    .isActive = true
        hStackView_2.centerXAnchor
                    .constraint(equalTo: hStackView_1.centerXAnchor)
                    .isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(320)) {
            self.flashView.start()
        }
    }
    
    @objc private func switchColor(_ ctrl: UISegmentedControl) {
        switch ctrl.selectedSegmentIndex {
        case 0:
            flashView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        case 1:
            flashView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
        case 2:
            flashView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.7)
        default:
            break
        }
    }
    
    @objc private func switchDuration(_ ctrl: UISegmentedControl) {
        switch ctrl.selectedSegmentIndex {
        case 0:
            flashView.duration = 0.55
        case 1:
            flashView.duration = 2
        case 2:
            flashView.duration = 4
        case 3:
            flashView.duration = 6
        default:
            break
        }
    }
}
