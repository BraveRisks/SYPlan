//
//  WatermarkDemoViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/9/10.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class WatermarkDemoViewController: UIViewController {

    private var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let count = navigationController?.viewControllers.count {
            print("⚠️ WatermarkDemoViewController count：\(count)")
        }
    }
    
    deinit {
        print("⚠️ WatermarkDemoViewController deinit")
    }

    private func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                           target: self,
                                                           action: #selector(refreshUserID(_:)))
        
        view.backgroundColor = UIColor(hex: "f2f2f2")
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.addCell(UITableViewCell.self, isNib: false)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView!)
        
        tableView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let btn = UIButton(type: .system)
        btn.setTitle("約看", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        btn.backgroundColor = UIColor(hex: "8BC34A")
        btn.layer.cornerRadius = 27.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "ic_more"), for: .normal)
        btn2.addTarget(self, action: #selector(showActionSheet(_:)), for: .touchUpInside)
        btn2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn2)
        
        btn.widthAnchor.constraint(equalToConstant: 54.0).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0).isActive = true
        
        btn2.widthAnchor.constraint(equalToConstant: 54.0).isActive = true
        btn2.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        btn2.trailingAnchor.constraint(equalTo: btn.trailingAnchor).isActive = true
        btn2.bottomAnchor.constraint(equalTo: btn.topAnchor, constant: -16.0).isActive = true
        
        addWatermark()
    }
    
    @objc private func refreshUserID(_ barButton: UIBarButtonItem) {
        refreshWatermark(with: "\(Int.random(in: 100000 ... 999999))")
    }
    
    @objc private func showActionSheet(_ btn: UIButton) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let streetView = UIAlertAction(title: "街景", style: .default, handler: nil)
        let navigation = UIAlertAction(title: "導航", style: .default, handler: nil)
        let favorite = UIAlertAction(title: "收藏", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "關閉", style: .cancel, handler: nil)
        
        ac.addAction(streetView)
        ac.addAction(navigation)
        ac.addAction(favorite)
        ac.addAction(cancel)
        
        present(ac, animated: true, completion: nil)
    }
}

extension WatermarkDemoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = "\(index)"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        return cell
    }
}
