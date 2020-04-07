//
//  LinkDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2020/3/20.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//  Reference: https://stackoverflow.com/questions/2543967/how-to-intercept-click-on-link-in-uitextview/38123226#38123226

import UIKit

class LinkDemoVC: UIViewController {

    enum Mode {
        
        case dataDetectorTypes(link: String)
        
        case delegate(link: String)
        
        case nsAttributedString(link: String)
    }
    
    private var tableView: UITableView!
    
    private let datas: [String] = [
        "Dart https://dart.dev/guides/language/language-tour#a-basic-dart-program",
        "Mobile https://www.mobile01.com/category.php?id=6",
        "點擊進入;信義房屋#https://www.sinyi.com.tw/"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.addCell(LinkDemoCell.self)
        tableView.rowHeight = 60.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension LinkDemoVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueCell(LinkDemoCell.self, indexPath: indexPath)
        
        let link = datas[index]
        switch index {
        case 0:
            cell.mode = .dataDetectorTypes(link: link)
        case 1:
            cell.mode = .delegate(link: link)
        case 2:
            cell.mode = .nsAttributedString(link: link)
            cell.delegate = self
        default: break
        }
        
        return cell
    }
}

extension LinkDemoVC: LinkDemoCellDelegate {
    func didClickedURL(cell: LinkDemoCell, url: URL) {
        
        if url.absoluteString == "https://www.sinyi.com.tw/" {
            navigationController?.popViewController(animated: true)
        }
    }
}
