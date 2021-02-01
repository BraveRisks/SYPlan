//
//  TabSwipeContainerVC.swift
//  SYPlan
//
//  Created by Ray on 2021/1/12.
//  Copyright © 2021 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class TabSwipeContainerVC: BaseVC {
    
    enum Page {
        
        /// 地圖模式
        case map
        
        /// 列表模式
        case list
    }
    
    private lazy var listVC: FacebookWebDemoViewController = {
        let vc = FacebookWebDemoViewController(nibName: "FacebookWebDemoViewController", bundle: nil)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        return vc
    }()
    
    private lazy var mapVC: GoogleMapDemoVC = {
        let vc = GoogleMapDemoVC()
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        return vc
    }()
    
    private var vcs: [UIViewController] = []
    
    var page: Page = .list
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        vcs.forEach {
            $0.view.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        }
    }
    
    private func setup() {
        switch page {
        case .list:
            vcs.append(listVC)
        case .map:
            vcs.append(mapVC)
        }
    }

    public func changePage(position: (lat: Double, lng: Double)?) {
        page = page == .list ? .map : .list
        
        switch page {
        case .list:
            guard vcs.contains(listVC) else {
                vcs.append(listVC)
                mapVC.view.isHidden = true
                return
            }
            
            listVC.view.isHidden = false
            mapVC.view.isHidden = true
        case .map:
            guard vcs.contains(mapVC) else {
                mapVC.animateTo(position: position)
                vcs.append(mapVC)
                listVC.view.isHidden = true
                return
            }
            
            listVC.view.isHidden = true
            mapVC.view.isHidden = false
        }
    }
}
