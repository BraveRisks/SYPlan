//
//  ApiDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2019/12/19.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class ApiDemoVC: UIViewController {

    private var textView: UITextView?
    
    private var hStackViewBottomConstraint: NSLayoutConstraint!
    
    private var values: String = ""
    
    private var tasks: Dictionary<ApiRequest, Int> = [:]
    private var t: Dictionary<Int, String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            hStackViewBottomConstraint.constant = -(view.safeAreaInsets.bottom + 10)
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        textView = UITextView()
        textView?.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        textView?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        textView?.textContainer.lineFragmentPadding = 1.2
        textView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView!)
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 8.0
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add Button
        let titles = ["Start Fetch", "Cancel"]
        for (index, title) in titles.enumerated() {
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = index == 0 ? .systemBlue : .systemRed
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
            btn.tag = index
            btn.layer.cornerRadius = 6.0
            btn.addTarget(self, action: #selector(clicked(_:)), for: .touchUpInside)
            hStackView.addArrangedSubview(btn)
        }
        view.addSubview(hStackView)
        
        textView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        textView?.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: 10.0).isActive = true
        textView?.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -10.0).isActive = true
        textView?.bottomAnchor.constraint(equalTo: hStackView.topAnchor,
                                          constant: -10.0).isActive = true
        
        hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                            constant: 10.0).isActive = true
        hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                             constant: -10.0).isActive = true
        
        hStackViewBottomConstraint = hStackView.bottomAnchor.constraint(
                                                    equalTo: view.bottomAnchor,
                                                    constant: -10.0)
        hStackViewBottomConstraint.isActive = true
        
        hStackView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    @objc private func clicked(_ btn: UIButton) {
        values = ""
        textView?.text = values
        
        if btn.tag == 0 {
            ApiManager.cancelAll()
            
            values += "開始取得潛賣客戶列表"
            searchCustomerList(with: "2")
            
            values += "\n開始取得常用會面地點"
            getMeetPlace()
            
            values += "\n開始取得委賣客戶列表"
            searchCustomerList(with: "3")
        } else {
            ApiManager.cancelAll()
        }
    }
    
    private func searchCustomerList(with type: String) {
        let parameters = ["SearchKeyWord": "", "CustType": type]
        let req = ApiRequest(method: .post, path: .searchCustomerList, parameters: parameters)
        
        ApiManager.request(from: req) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.values += "\n取得\(type == "2" ? "潛賣" : "委賣")客戶列表成功"
            case .failure(let error):
                self?.values += "\n取得\(type == "2" ? "潛賣" : "委賣")客戶列表發生錯誤：\(error.message)"
            }
            
            self?.textView?.text = self?.values
        }
    }
    
    private func getMeetPlace() {
        let req = ApiRequest(method: .post, path: .getMeetPlace)
        ApiManager.request(from: req) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.values += "\n取得常用會面地點成功"
            case .failure(let error):
                self?.values += "\n取得常用會面地點發生錯誤：\(error.message)"
            }
            
            self?.textView?.text = self?.values
        }
    }
}
