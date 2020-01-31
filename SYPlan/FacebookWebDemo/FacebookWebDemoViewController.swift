//
//  FacebookWebDemoViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/10/16.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class FacebookWebDemoViewController: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    private let viewModel: ArticleViewModel = ArticleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setup() {
        if let url = Bundle.main.url(forResource: "articles", withExtension: ".json"),
            let data = try? Data(contentsOf: url) {
            viewModel.data = data
        }
        
        mTableView.addCell(ArticleTableViewCell.self)
        mTableView.separatorStyle = .none
        mTableView.dataSource = self
        mTableView.delegate = self
    }
}
extension FacebookWebDemoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.articles[indexPath.row].rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueCell(ArticleTableViewCell.self, indexPath: indexPath)
        cell.article = viewModel.articles[index] as? Article
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let web = WebViewController()
        web.modalPresentationStyle = .overCurrentContext
        present(web, animated: true, completion: nil)
    }
}
