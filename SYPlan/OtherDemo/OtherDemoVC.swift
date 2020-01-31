//
//  OtherDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2019/10/30.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import UIKit
import StoreKit
import Toaster

class OtherDemoVC: UIViewController {
    
    private var tableView: UITableView?
    
    private let datas: [String] = [
        "📢 Local Notification",
        "⭐️ App Store Reviews",
        "⭐️ App Store Infomation Reviews",
        "🌀 Automatic Add Count By UserDefault"
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
        
        ToastView.appearance().bottomOffsetPortrait = 200.0
    }
    
    @available(iOS 10.0, *)
    private func showNotification() {
        let content = UNMutableNotificationContent()
        content.title = "體驗過了，才是你的。"
        content.subtitle = "米花兒"
        content.body = "不要追問為什麼，就笨拙地走入未知。感受眼前的怦然與顫抖，聽聽左邊的碎裂和跳動。不管好的壞的，只有體驗過了，才是你的。"
        content.badge = 1
        content.sound = UNNotificationSound.default
        content.userInfo = ["link": "https://www.mobile01.com/"]
        // 對應ApplicationDelegate的名稱
        content.categoryIdentifier = "category"
        
        // add image
        // 橫 --> mobile01_20180727_4
        // 直 --> mobile01_20180727_6
        let imageURL = Bundle.main.url(forResource: "mobile01_20180727_4", withExtension: "jpg")
        let attachment = try! UNNotificationAttachment(identifier: "", url: imageURL!, options: nil)
        content.attachments = [attachment]
        
        //UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print("Error --> \(String(describing: error?.localizedDescription))")
        }
    }
    
    // 顯示App評分Dialog
    private func requestStoreReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id362879359?action=write-review")
                else {
                    fatalError("Expected a valid URL")
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(writeReviewURL)
            }
        }
    }
    
    // 預覽App商店畫面，必須用實機測試
    private func requestAppStoreInfomation() {
        #if targetEnvironment(simulator)
        let toast = Toast(text: "模擬器不支援該功能！", delay: 0.0, duration: Delay.short)
        toast.show()
        #else
        let vc = SKStoreProductViewController()
        vc.delegate = self
        vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: 443904275]) { (result, err) in
            if let err = err {
                print("SKStoreProductViewController Error --> \(err.localizedDescription)")
            } else {
                print("SKStoreProductViewController Result --> \(result)")
            }
        }
               
        present(vc, animated: true, completion: nil)
        #endif
    }
    
    /// 自動增加計數
    private func testAutomaticAddCount() {
        let key = "AutomaticAddCount"
        
        let ac = UIAlertController(title: nil, message: "動作", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "清除", style: .cancel, handler: { (action) in
            UserDefaults.standard.removeObject(forKey: key)
            
            let count = UserDefaults.standard.integer(forKey: key)
            let toast = Toast(text: "Count = \(count)", delay: 0.0, duration: Delay.short)
            toast.show()
        }))
        
        ac.addAction(UIAlertAction(title: "測試", style: .default, handler: { (action) in
            let `init` = UserDefaults.standard.integer(forKey: key)
            UserDefaults.standard.set(`init` + 1, forKey: key)
            
            let count = UserDefaults.standard.integer(forKey: key)
            let toast = Toast(text: "Count = \(count)", delay: 0.0, duration: Delay.short)
            toast.show()
        }))
        
        present(ac, animated: true, completion: nil)
    }
}

extension OtherDemoVC: UITableViewDataSource, UITableViewDelegate {
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
        
        switch indexPath.row {
        case 0:
            if #available(iOS 10.0, *) { showNotification() }
        case 1:
            requestStoreReview()
        case 2:
            requestAppStoreInfomation()
        case 3:
            testAutomaticAddCount()
        default: break
        }
    }
}

extension OtherDemoVC: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
        print("productViewControllerDidFinish")
    }
}
