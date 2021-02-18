//
//  AppDelegate.swift
//  SYPlan
//
//  Created by Ray on 2018/6/1.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import CoreData
import RealmSwift
import FBSDKCoreKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Use for URLSessionViewController，default = nil
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    /// Home screen quick action，default = nil
    var shortcutItem: UIApplicationShortcutItem?
    
    /// Core Data
    /// 載入需要的Core Data Model
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        // 載入資料有2種方式
        // 1. 指定資料庫位置
        let url = Bundle.main.url(forResource: "Person", withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: url!)
        let container = NSPersistentContainer(name: "Person", managedObjectModel: model!)
        // 2. 依名稱系統自動抓取
        //let container = NSPersistentContainer(name: "Person")
        
        // 以下將Database為`NSInMemoryStoreType`，資料只會儲存在記憶體裡面，App離開後資料即會消失
        // 參考文章 👉🏻 https://koromiko1104.wordpress.com/2017/10/05/unit-test-for-core-data/
        /*let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        desc.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [desc]*/
        
        container.loadPersistentStores(completionHandler: { (storeDesc, error) in
            if let err = error as NSError? {
                fatalError("Unresolved error \(err) = \(err.userInfo)")
            }
            // storeDesc 👉🏻 CoreData路徑
            print("loadPersistentStores = \(storeDesc)")
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Life circle application didFinishLaunchingWithOptions")
        
        // Firebase
        let filePath = Bundle.main.path(forResource: "GoogleService-Info",
                                        ofType: "plist")!
        
        guard let options = FirebaseOptions(contentsOfFile: filePath) else {
            fatalError("Couldn't load firebase config .plist from \(filePath)")
        }
        
        FirebaseApp.configure(options: options)
        
        /*
         Google Ad
         
         Update your Info.plist
         <key>GADApplicationIdentifier</key>
         <string>ca-app-pub-3940256099942544~1458002511</string>
         <key>GADIsAdManagerApp</key>
         <true/>
        */
        GADMobileAds.sharedInstance().start { (status) in
            print("⚠️ GADMobileAds is \(status.adapterStatusesByClassName)")
        }
        
        // Google Map
        GMSServices.provideAPIKey("AIzaSyA2nA6h8NQpXL5A3qTNnll24AiL3R5chbs")
        
        // Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        /*
         20190705(Fri) 最新Facebook SDK功能
         全新隱私設定功能
         1.延遲 Android 或 iOS 的自動事件記錄 - 暫停記錄應用程式事件（如應用程式安裝和應用程式啟動），直到取得用戶同意為止。
         2.延遲 Android 或 iOS 的 SDK 初始化 - 封鎖所有網路要求，直到取得用戶同意為止。
         
         上述2點，需在.plist檔增加下列key-value
         
         暫停記錄應用程式事件
         1. App Install
         2. App Launch
         3. In-App Purchase
         <key>FacebookAutoLogAppEventsEnabled</key>
         <false/>
         
         Facebook SDK初始化
         <key>FacebookAutoInitEnabled</key>
         <false/>
         
         收集廣告商ID
         <key>FacebookAdvertiserIDCollectionEnabled</key>
         <false/>
         
         如上述的值設為false，那可在程式啟動後透過詢問方式(自行建立，SDK不會提供)來取得用戶的同意，
         當取得同意後透過程式來啟用如下：
         Settings.isAutoLogAppEventsEnabled = true
         ApplicationDelegate.initializeSDK(launchOptions)
         Settings.isAdvertiserIDCollectionEnabled = true
         
         反之值設為true，則不用取得用戶同意即可啟用
         */
        Settings.isAutoLogAppEventsEnabled = true
        
        // Realm Config 指定資料庫名稱
        /*var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("SYPlan.realm")
        Realm.Configuration.defaultConfiguration = config*/
        
        // 遷移資料庫
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Person object stored in the Realm file
                    /*migration.enumerateObjects(ofType: RealmPerson.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        let firstName = oldObject!["name"] as! String
                        let lastName = oldObject!["lastName"] as! String
                        newObject!["fullName"] = "\(firstName) \(lastName)"
                    }*/
                }
        })
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL = config.fileURL!
                               .deletingLastPathComponent()
                               .appendingPathComponent("SYPlan.realm")
        Realm.Configuration.defaultConfiguration = config
        
        print("Realm URL = \(String(describing: config.fileURL))")
        print("Realm schemaVersion = \(String(describing: config.schemaVersion))")
        
        // Notifacation
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            var options: UNAuthorizationOptions = [.badge, .sound, .alert]
            
            // provisional：不會跳出推播通知權限請求，而是會在通知中心來讓使用者決定是否繼續接收通知
            if #available(iOS 12.0, *) {
                options = [.badge, .sound, .alert, .provisional]
            }
            
            UNUserNotificationCenter.current().requestAuthorization(options: options)
            { (success, error) in
                if error == nil {
                    // 註冊遠端通知
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
            
            // Notification add action
            let install = UNNotificationAction(identifier: "install",
                                               title: "安裝",
                                               options: .foreground)
            
            let nexttime = UNNotificationAction(identifier: "nexttime",
                                                title: "下次再安裝",
                                                options: [])
            
            let category = UNNotificationCategory(identifier: "category",
                                                  actions: [install, nexttime],
                                                  intentIdentifiers: [],
                                                  options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
        } else {
           let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert],
                                                     categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            
            // 註冊遠端通知
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        // 檢查是否從 Quick Action 啟動App
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            self.shortcutItem = shortcutItem
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Life circle application willEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("Life circle application didBecomeActive")
        
        application.applicationIconBadgeNumber = 0
        AppEvents.activateApp()
        
        // 處理Quick Actions 事件
        guard let item = shortcutItem else { return }
        
        let tabVC = window?.rootViewController as? TabBarController
        switch item.type {
        case "QRCode":
            tabVC?.setTabIndex(on: 0, content: .qrCode)
        case "Web":
            tabVC?.setTabIndex(on: 0, content: .fbWeb)
        case "Download":
            tabVC?.setTabIndex(on: 1, content: .download)
        default: break
        }
        
        // Reset the shorcut item so it's never processed twice.
        shortcutItem = nil
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // 設定 Home Screen Quick Actions
        let items: [ShortcutItem] = [.qrCode, .web, .download]
        application.shortcutItems = items.map({ $0.item })
        
        print("Life circle application willResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Life circle application didEnterBackground")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.\
        print("Life circle application willTerminate")
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("Life circle application didFinishLaunching")
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        /*
         DeepLink absoluteString --> deep://deeplink/index
         DeepLink absoluteURL --> deep://deeplink/index
         DeepLink path --> /index
         DeepLink host --> "deeplink.com"
         DeepLink query --> "index=1" or "index=1&limit=5"
         
         DeepLink absoluteString --> syplan://chat?memberId=999
         DeepLink absoluteURL --> syplan://chat?memberId=999
         DeepLink host --> Optional("chat")
         DeepLink path -->
         DeepLink query --> Optional("memberId=999")
         DeepLink queryParameters --> Optional(["memberId": "999"])
         */
        print("DeepLink absoluteString --> \(url.absoluteString)")
        print("DeepLink absoluteURL --> \(url.absoluteURL)")
        print("DeepLink host --> \(String(describing: url.host))")
        print("DeepLink path --> \(url.path)")
        print("DeepLink query --> \(String(describing: url.query))")
        print("DeepLink queryParameters --> \(String(describing: url.queryParameters))")
        
        if let host = url.host,
            host == "routes",
            let parameters = url.queryParameters,
            let page = parameters["page"],
            page == "regular" {
            
            let tabVC = window?.rootViewController as? TabBarController
            tabVC?.setTabIndex(on: 2, content: .regular)
        }
        
        // Facebook
        let source = UIApplication.OpenURLOptionsKey.sourceApplication.rawValue
        let annotation = UIApplication.OpenURLOptionsKey.annotation
        let handle = ApplicationDelegate.shared.application(app,
                                                            open: url,
                                                            sourceApplication: source,
                                                            annotation: annotation)
        return handle
    }
    
    /// Universal Links
    /// Reference: https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content/supporting_universal_links_in_your_app
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let webURL = userActivity.webpageURL,
              let components = NSURLComponents(url: webURL, resolvingAgainstBaseURL: true) else {
            return false
        }
        
        // Check for specific URL components that you need.
        guard let path = components.path,
              let params = components.queryItems else {
            // path = /demo/
            print("path = \(components.path?.split(separator: "/").last)")
            return false
        }
        
        // path = /demo/
        // params = [number=plan1234]
        print("path = \(path), params = \(params)")

        if let number = params.first(where: { $0.name == "number" } )?.value {
            print("number = \(number)")
            let tabVC = window?.rootViewController as? TabBarController
            tabVC?.setTabIndex(on: 0, content: .fbWeb)
            return true
        } else {
            print("Content not found")
            return false
        }
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 取得遠端推播token
        var tokenString = ""
        for byte in deviceToken {
            let hexString = String(format: "%02x", byte)
            tokenString += hexString
        }
        
        // or like this
        let _ = deviceToken.reduce("") {
            return $0 + String(format: "%02x", $1)
        }
        
        print("📢 didRegisterForRemoteNotificationsWithDeviceToken \(tokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("📢 APNs registration failed: \(error)")
    }
    
    /// 觸發Quick Action事件
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        self.shortcutItem = shortcutItem
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 當 App 本來就在前景，收到推播時則會觸發 userNotificationCenter(:willPresent:withCompletionHandler:)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let content = notification.request.content
        if let link = content.userInfo["link"] as? String {
            print("willPresent link --> \(link)")
        }
        
        completionHandler([.badge, .sound, .alert])
    }
    
    // 當使用者點選推播打開`App`時，將觸發 userNotificationCenter(:didReceive:withCompletionHandler:)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let content = response.notification.request.content
        if let link = content.userInfo["link"] as? String {
            print("didReceive link --> \(link)")
        }
        
        // 取得使用者點擊哪個Action
        let witch = response.actionIdentifier
        print("didReceive action --> \(witch)")
        
        completionHandler()
    }
}
