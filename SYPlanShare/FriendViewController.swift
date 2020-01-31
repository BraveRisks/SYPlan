//
//  FriendViewController.swift
//  SYPlanShare
//
//  Created by Ray on 2018/8/15.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

protocol FriendViewControllerDelegate: class {
    func selectedFriendName(name: String)
}

class FriendViewController: UIViewController {

    private var mTableView: UITableView!
    private let friends = ["Ray", "Aida", "Jhon", "Paul", "Mary", "Jane", "Frank"]
    
    weak var delegate: FriendViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupView() {
        mTableView = UITableView(frame: CGRect.zero, style: .plain)
        mTableView.dataSource = self
        mTableView.delegate = self
        view.addSubview(mTableView)
        mTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: mTableView, attribute: .top,
                           relatedBy: .equal,
                           toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView, attribute: .leading,
                           relatedBy: .equal,
                           toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView, attribute: .trailing,
                           relatedBy: .equal,
                           toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView, attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
    }
}
extension FriendViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = friends[index]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let index = indexPath.row
        delegate?.selectedFriendName(name: friends[index])
        navigationController?.popViewController(animated: true)
    }
}
