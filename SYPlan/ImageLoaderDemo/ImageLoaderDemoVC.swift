//
//  ImageLoaderDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2020/2/25.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class ImageLoaderDemoVC: UIViewController {

    private var tableView: UITableView?
    private let paths: [String] = [
        "http://www.bntnews.cn/images/news/2019/bzrp53x5q3567o76ec0tximk2akdxjxz.jpg",
        "https://imgs.niusnews.com/upload/imgs/default/2018AugM/Abyss/012.jpg",
        "https://assets.juksy.com/files/articles/85477/800x_100_w-5c08fb84abf99.jpg",
        "https://i2.kknews.cc/SIG=3icn9pl/ctp-vzntr/00srns859sr04o10n4450219q3on45n3.jpg",
        "https://i1.kknews.cc/SIG=tos16p/ctp-vzntr/58oo21s3o15641sp947q783q0s53oo36.jpg",
        "https://up.enterdesk.com/edpic_360_360/c6/df/95/c6df953c0512419d2c74b682a2ea7096.jpg",
        "https://i2.kknews.cc/SIG=38lohod/134o0006560np09479o7.jpg",
        "https://images.chinatimes.com/newsphoto/2019-11-23/900/20191123001228.jpg",
        "https://a.ksd-i.com/a/2019-09-26/120513-774720.jpg",
        "https://news.cts.com.tw/photo/cts/201903/201903281956128_l.jpg",
        "https://images.chinatimes.com/newsphoto/2016-10-14/900/20161014003105.jpg",
        "https://img2.ali213.net/picfile/News/2018/10/13/584_90892ed7f4d330c97195c7d4badf610c.jpg",
        "https://i2.wp.com/inews.gtimg.com/newsapp_match/0/1447746561/0",
        "https://imgs.fun1shot.com/c7a0083c763a604a715f492d96e35085.jpeg",
        "https://5b0988e595225.cdn.sohucs.com/images/20191021/20645577ac26462888abb48a1e94e7ec.png",
        "https://n.sinaimg.cn/sinacn10108/560/w1080h1080/20190624/1152-hyvnhqq1620185.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.addCell(ImageLoaderCell.self)
        tableView?.tableFooterView = UIView()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView!)
        
        tableView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ImageLoaderDemoVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueCell(ImageLoaderCell.self, indexPath: indexPath)
        
        let path = paths[index]
        let uuid = ImageLoader.share.load(path: path) { (result) in
            switch result {
            case .success(let image):
                cell.item = (image, path)
            case .failure(let error):
                cell.item = (nil, nil)
                print("ImageLoader error = \(error.description)")
            }
        }
        
        cell.onReuse = {
            if let uuid = uuid {
                ImageLoader.share.cancelLoad(uuid, path)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
