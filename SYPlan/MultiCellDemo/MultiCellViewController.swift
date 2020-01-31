//
//  MultiCellViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/8/21.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class MultiCellViewController: UIViewController {
    
    private var mTableView: UITableView!
    private lazy var mRefreshCtrl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .orange
        refresh.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        return refresh
    }()
    
    private var isLoadMore: Bool = false
    private var isNoDataMore: Bool = false
    
    private var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    private var session: URLSession!
    private var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchProfile()
        lookURLCache()
        print("application viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("application viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("application viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("application viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("application viewDidDisappear")
    }

    private func setupView() {
        mTableView = UITableView(frame: .zero, style: .plain)
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.addCell(ProfileTableCell.self)
        mTableView.addCell(AboutTableCell.self)
        mTableView.addCell(EmailTableCell.self)
        mTableView.addCell(FriendTableCell.self)
        
        if #available(iOS 10.0, *) {
            mTableView.refreshControl = mRefreshCtrl
        } else {
            mTableView.addSubview(mRefreshCtrl)
        }
        
        view.addSubview(mTableView)
        mTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: mTableView!, attribute: .top,
                           relatedBy: .equal,
                           toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .leading,
                           relatedBy: .equal,
                           toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .trailing,
                           relatedBy: .equal,
                           toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    private func fetchProfile() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5.0
        configuration.timeoutIntervalForResource = 5.0
        // 設置請求表頭
        let min = 60
        configuration.httpAdditionalHeaders = ["cache-control": "max-age=\(min * 5)"]
        // 設置緩存
        let capacity = 1024 * 1024 * 10
        configuration.urlCache = URLCache(memoryCapacity: capacity / 10, diskCapacity: capacity, diskPath: nil)
    
        session = URLSession(configuration: configuration)
        dataTask?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        mRefreshCtrl.beginRefreshing()
        dataTask = session.dataTask(with: URL(string: "http://10.30.2.84:3001/apitest/v1/profile")!, completionHandler: { (data, res, error) in
            defer { self.dataTask = nil }
            
            let decoder = JSONDecoder()
            if let res = res as? HTTPURLResponse, res.statusCode == 200,
                let data = data, let profile = try? decoder.decode(Profile.self, from: data) {
                for (key, value) in res.allHeaderFields {
                    print("header key --> \(key) value --> \(value)")
                }
                self.profileViewModel.data = profile
                self.session.finishTasksAndInvalidate()
            }
            
            DispatchQueue.main.async {
                self.mTableView.reloadData()
                if self.mRefreshCtrl.isRefreshing { self.mRefreshCtrl.endRefreshing() }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
        
        dataTask?.resume()
    }
    
    private func fetchProfileFriendsForMore() {
        isLoadMore = true
        session = URLSession(configuration: .default)
        dataTask?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dataTask = session.dataTask(with: URL(string: "http://10.30.2.84:3001/apitest/v1/profilefriends")!, completionHandler: { (data, res, error) in
            defer { self.dataTask = nil }
            
            if let res = res as? HTTPURLResponse, res.statusCode == 200, let data = data,
                let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let dictFriends = dict["friends"] as? [[String: Any]] {
                //print("dictFriends --> \(dictFriends)")
                var friends: [Profile.Friend] = []
                for f in dictFriends {
                    let name = f["name"] as! String
                    let photo = f["photo"] as! String
                    let gender = f["gender"] as! Bool
                    friends.append(Profile.Friend(name: name, photo: photo, gender: gender))
                }
                self.profileViewModel.friends = friends
                self.session.finishTasksAndInvalidate()
            }
            
            DispatchQueue.main.async {
                let indexSet = IndexSet(integer: self.profileViewModel.items.count - 1)
                self.mTableView.reloadSections(indexSet, with: .automatic)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.isLoadMore = false
            }
        })
        
        dataTask?.resume()
    }
    
    private func lookURLCache() {
        let urlCache = URLCache.shared

        // 記憶體大小：memoryCapacity           --> 512000(~0.48MB)
        // 硬碟空間大小：diskCapacity           --> 10000000(~9.5MB)
        // 已使用記憶體大小：currentMemoryUsage  --> 0
        // 已使用硬碟空間大小：currentDiskUsage   --> 156376

        let info = """
                   memoryCapacity     --> \(urlCache.memoryCapacity)
                   diskCapacity       --> \(urlCache.diskCapacity)
                   currentMemoryUsage --> \(urlCache.currentMemoryUsage)
                   currentDiskUsage   --> \(urlCache.currentDiskUsage)
                   """
        print("URLCache Info --> \(info)")
        
        // 清除緩存資料
        //urlCache.removeAllCachedResponses()
    }
    
    @objc private func onRefresh(_ ctrl: UIRefreshControl) {
        fetchProfile()
    }
}
extension MultiCellViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileViewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileViewModel.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return profileViewModel.items[indexPath.section].rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let index = indexPath.row
        let item = profileViewModel.items[section]
        switch item.type {
        case .profile:
            let cell = tableView.dequeueCell(ProfileTableCell.self, indexPath: indexPath)
            if let item = profileViewModel.items[section] as? ProfileItem {
                cell.datas = (item.name, item.photo)
                return cell
            }
        case .about:
            let cell = tableView.dequeueCell(AboutTableCell.self, indexPath: indexPath)
            if let item = profileViewModel.items[section] as? AboutItem {
                cell.data = item.desc
                return cell
            }
        case .email:
            let cell = tableView.dequeueCell(EmailTableCell.self, indexPath: indexPath)
            if let item = profileViewModel.items[section] as? EmailItem {
                cell.data = item.email
                return cell
            }
        case .friends:
            let cell = tableView.dequeueCell(FriendTableCell.self, indexPath: indexPath)
            if let item = profileViewModel.items[section] as? FriendsItem {
                cell.data = item.friends[index]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let index = indexPath.row
        // Load more data.
        if profileViewModel.items[section].type == .friends, let item = profileViewModel.items[section] as? FriendsItem {
            if item.friends.count < 60 && index == item.friends.count - 1 {
                fetchProfileFriendsForMore()
            } else if item.friends.count >= 60 && !isNoDataMore {
                isNoDataMore = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Load more data 2.
        /*if profileViewModel.items.count == 4 && profileViewModel.items[3].rowCount > 50 { return }
        
        if let tableView = scrollView as? UITableView {
            let cells = tableView.visibleCells
            for cell in cells {
                let y = cell.frame.origin.y
                let h = cell.frame.size.height
                if y + h > tableView.contentSize.height - 120.0 && !isLoadMore {
                    let index = tableView.indexPath(for: cell)
                    print("fetch load more data. 1 --> \(index?.section) - \(index?.row)")
                    print("fetch load more data. 2 --> \(isLoadMore) - \(cell)")
                    fetchProfileFriendsForMore()
                    break
                }
            }
        }*/
    }
}
