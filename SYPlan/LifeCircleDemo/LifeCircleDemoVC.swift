//
//  LifeCircleDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2020/11/11.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

/// Life Circle
/// ```
/// LifeCircleDemoVC viewDidLoad
/// LifeCircleDemoVC viewWillAppear
/// LifeCircleDemoVC viewDidLayoutSubviews
/// LifeCircleDemoVC viewDidAppear
///
/// present other viewcontroller (if present UIAlertController 不會觸發Life Circle)
///
/// LifeCircleDemo2VC viewDidLoad
/// LifeCircleDemoVC  viewWillDisappear
/// LifeCircleDemo2VC viewWillAppear
/// LifeCircleDemo2VC viewDidLayoutSubviews
/// LifeCircleDemo2VC viewDidLayoutSubviews
/// LifeCircleDemo2VC viewDidAppear
/// LifeCircleDemoVC  viewDidDisappear
///
/// dismiss viewcontroller
///
/// LifeCircleDemo2VC viewWillDisappear
/// LifeCircleDemoVC  viewWillAppear
/// LifeCircleDemoVC  viewDidAppear
/// LifeCircleDemo2VC viewDidDisappear
/// ```
class LifeCircleDemoVC: UIViewController {

    private var label: UILabel?
    private var tableView: UITableView?
    
    var value: String? {
        didSet { print("LifeCircleDemoVC didSet = step 1") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LifeCircleDemoVC viewDidLoad")
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LifeCircleDemoVC viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("LifeCircleDemoVC viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("LifeCircleDemoVC viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("LifeCircleDemoVC viewDidDisappear")
    }
    
    override func viewDidLayoutSubviews() {
        print("LifeCircleDemoVC viewDidLayoutSubviews")
        var safeAreaBottom: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            safeAreaBottom = view.safeAreaInsets.bottom
        } else {
            safeAreaBottom = view.layoutMargins.bottom
        }
        
        tableView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: safeAreaBottom, right: 0.0)
    }

    private func setup() {
        print("LifeCircleDemoVC viewDidLoad = step 2")
        
        label = UILabel()
        label?.text = "didSet before viewDidLoad"
        label?.font = .systemFont(ofSize: 18.0, weight: .medium)
        label?.textColor = UIColor.gray.withAlphaComponent(0.8)
        label?.numberOfLines = 0
        label?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label!)

        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.addCell(LifeCircleCell.self, isNib: false)
        tableView?.rowHeight = 80.0
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView!)

        // AutoLayout
        label?.topAnchor
              .constraint(equalTo: view.topAnchor, constant: 20.0)
              .isActive = true
        label?.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 16.0)
              .isActive = true
        label?.trailingAnchor
              .constraint(equalTo: view.trailingAnchor, constant: -16.0)
              .isActive = true

        tableView?.topAnchor
                  .constraint(equalTo: label!.bottomAnchor)
                  .isActive = true
        tableView?.leadingAnchor
                  .constraint(equalTo: label!.leadingAnchor)
                  .isActive = true
        tableView?.trailingAnchor
                  .constraint(equalTo: label!.trailingAnchor)
                  .isActive = true
        tableView?.bottomAnchor
                  .constraint(equalTo: view.bottomAnchor)
                  .isActive = true
        
        view.backgroundColor = .white
    }
}

extension LifeCircleDemoVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(LifeCircleCell.self, indexPath: indexPath)
        cell.value = "didSet on \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row % 2 == 0 {
            let vc = LifeCircleDemo2VC()
            present(vc, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Life Circle", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "關閉", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
}

extension LifeCircleDemoVC {
    
    class LifeCircleCell: UITableViewCell {
        
        private var label: UILabel?
        
        var value: String? {
            didSet {
                guard let text = label?.text else {
                    label?.text = value
                    return
                }
                
                label?.text = "\(text) before \(value ?? "empty")"
            }
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            label?.text = "init"
            super.prepareForReuse()
        }
        
        private func setup() {
            label = UILabel()
            label?.text = "init"
            label?.font = .systemFont(ofSize: 18.0, weight: .medium)
            label?.textColor = UIColor.blue.withAlphaComponent(0.8)
            label?.numberOfLines = 0
            label?.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label!)
            
            // AutoLayout
            label?.heightAnchor
                  .constraint(equalToConstant: 50.0)
                  .isActive = true
            label?.leadingAnchor
                  .constraint(equalTo: contentView.leadingAnchor)
                  .isActive = true
            label?.centerYAnchor
                  .constraint(equalTo: contentView.centerYAnchor)
                  .isActive = true
        }
    }
}
