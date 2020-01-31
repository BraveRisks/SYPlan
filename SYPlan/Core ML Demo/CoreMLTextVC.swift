//
//  CoreMLTextVC.swift
//  SYPlan
//
//  Created by Ray on 2019/10/30.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//
// Reference: https://www.appcoda.com.tw/create-ml/

import UIKit
import NaturalLanguage

class CoreMLTextVC: UIViewController {

    private var tableView: UITableView?
    
    private let datas: [String] = [
        "It was the best I've ever seen!",
        "I plane to give on this month end.",
        "Did you hear about the new \\Divorce Barbie\\\"? It comes with all of Ken's stuff!",
        "HI BABE IM AT HOME NOW WANNA DO SOMETHING? XX",
        "U can call me now...",
        "Sunshine Quiz Wkly Q! Win a top Sony DVD player if u know which country the Algarve is in? Txt ansr to 82277. �1.50 SP:Tyrone",
        "He is there. You call and meet him",
        "I only haf msn. It's yijue@hotmail.com",
        "Customer service annoncement. You have a New Years delivery waiting for you. Please call 07046744435 now to arrange delivery",
        "BangBabes Ur order is on the way. U SHOULD receive a Service Msg 2 download UR content. If U do not, GoTo wap. bangb. tv on UR mobile internet/service menu",
        "What time you coming down later?",
        "U still going to the mall?"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .white
        
        tableView = UITableView()
        tableView?.addCell(UITableViewCell.self, isNib: false)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView!)
        
        tableView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func showAlert(with text: String?) {
        let ac = UIAlertController(title: "結果", message: text, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "關閉", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

extension CoreMLTextVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if #available(iOS 12.0, *) {
            let sentimentPredictor = try? NLModel(mlModel: SpamDetector().model)
            let result = sentimentPredictor?.predictedLabel(for: datas[indexPath.row])
            showAlert(with: result)
        }
    }
}
