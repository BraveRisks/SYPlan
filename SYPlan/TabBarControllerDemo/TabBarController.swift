//
//  TabViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/10/26.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let images = ["tabbar_ui", "tabbar_network", "tabbar_list" , "tabbar_apple"]
        var vcs: [UIViewController] = []
        
        for i in 0 ..< images.count {
            let type: ContainerViewController.`Type` = i == 0 ? .ui :
                                                       i == 1 ? .network :
                                                       i == 2 ? .other : .apple
            
            let vc = NavigationDemoSwipeController(rootViewController: ContainerViewController(type: type))
            vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: images[i]), tag: i)
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
            vcs.append(vc)
        }
        
        viewControllers = vcs
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor(hex: "d6374e")
        selectedIndex = 0
        
        UITabBar.appearance().layer.borderWidth = 0.0
    }
    
    public func setTabIndex(on index: Int, content: ContainerViewController.`Type`.Content) {
        selectedIndex = index
        
        guard let nac = viewControllers?[selectedIndex] as? NavigationDemoSwipeController else {
            return
        }
        
        switch content {
        case .qrCode:
            let vc = QRCodeDemoViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            nac.pushViewController(vc, animated: true)
        case .fbWeb:
            let vc = FacebookWebDemoViewController(nibName: "FacebookWebDemoViewController", bundle: nil)
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            nac.pushViewController(vc, animated: true)
        case .download:
            let vc = DownloadDemoController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            nac.pushViewController(vc, animated: true)
        default: break
        }        
    }
}
