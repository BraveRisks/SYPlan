//
//  ShareViewController.swift
//  SYPlanShare
//
//  Created by Ray on 2018/8/15.
//  Copyright © 2018年 Sinyi. All rights reserved.
//  http://www.cocoachina.com/ios/20170706/19749.html

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    // suitName --> 需與App group相同
    private let suitName = "group.SinyiSearch"
    private let imageKey = "ImageKey"
    private var selectedFriend = "Default"
    
    // 設定選擇分類Item
    private lazy var friendConfig: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()
        item?.title = "發送给朋友"
        item?.value = "請選擇"
        // tapHandler --> 按下時要做什麼事
        item?.tapHandler = self.goFriendVC
        // Loading圖示
        //item?.valuePending = true
        return item!
    }()
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        
        // 判斷內容是否符合
        // true ：符合
        // false：不符合
        return true
    }

    override func didSelectPost() {
        print("didSelectPost")
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        // http://sundeepgupta.ca/post/160841682296/ios-8-share-extension-example-in-swift
        // https://www.jianshu.com/p/c6b34eb5f753
        // https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/AppExtensionKeys.html#//apple_ref/doc/uid/TP40014212-SW1
        let item: NSExtensionItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let itemProvider: NSItemProvider = item.attachments![0] as! NSItemProvider
        
        // 取得的內容Type
        let typeIdentifier = kUTTypeImage as String
        print("typeIdentifier --> \(typeIdentifier)")
        
        if itemProvider.hasItemConformingToTypeIdentifier(typeIdentifier) {
            itemProvider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { (item, error) in
                
                // 取得資料後要做什麼事，這裡是將資訊儲存至UserDefault
                // 具體的用法看當時的需求
                
                var imgData: Data!
                if let url = item as? URL {
                    imgData = try! Data(contentsOf: url)
                    let image = UIImage(data: imgData)
                    print("imgData URL --> \(String(describing: imgData)) - \(String(describing: image))")
                }
                if let img = item as? UIImage {
                    imgData = UIImagePNGRepresentation(img)
                    print("imgData UIImage --> \(String(describing: imgData)) - \(img)")
                }
                let dict: [String : Any] = [
                    "imgData":  imgData,
                    "content": self.contentText,
                    "friend": self.selectedFriend
                ]
                let userDefault = UserDefaults(suiteName: self.suitName)
                userDefault?.setValue(dict, forKeyPath: self.imageKey)
                userDefault?.synchronize()
                
                print("item --> \(String(describing: item))")
                print("contentText --> \(String(describing: self.contentText))")
            }
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func didSelectCancel() {
        super.didSelectCancel()
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        
        // 設定分類Item，可設置多個
        return [friendConfig]
        //return []
    }

    private func goFriendVC() {
        let friend = FriendViewController()
        friend.delegate = self
        pushConfigurationViewController(friend)
    }
}
extension ShareViewController: FriendViewControllerDelegate {
    func selectedFriendName(name: String) {
        friendConfig.value = name
        selectedFriend = name
    }
}
