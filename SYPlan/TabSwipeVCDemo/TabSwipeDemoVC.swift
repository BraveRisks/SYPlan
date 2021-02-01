//
//  TabSwipeDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2021/1/11.
//  Copyright © 2021 Sinyi Realty Inc. All rights reserved.
//

import UIKit

// Reference: https://cocoacasts.com/managing-view-controllers-with-container-view-controllers
// 仿Siniy App 實價登錄 Screen
class TabSwipeDemoVC: BaseVC {

    enum Tab {
        
        /// 實價登錄
        case trade
        
        /// 銷售中物件
        case object
        
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagerTabView: UIPagerTabView!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    
    private var tab: Tab = .trade
    
    private var tradeContainerView: UIView = UIView()
    
    private var objectContainerView: UIView = UIView()
    
    private lazy var tradeVC: TabSwipeContainerVC = {
        let vc = TabSwipeContainerVC()
        vc.page = .list
        self.addChild(vc)
        scrollView.addSubview(vc.view)
        return vc
    }()
    
    private lazy var objectVC: TabSwipeContainerVC = {
        let vc = TabSwipeContainerVC()
        vc.page = .list
        self.addChild(vc)
        scrollView.addSubview(vc.view)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        let scrollW = scrollView.frame.width
        let scrollH = scrollView.frame.height
        
        tradeVC.view.frame = CGRect(x: 0.0, y: 0.0, width: scrollW, height: scrollH)
        objectVC.view.frame = CGRect(x: scrollW, y: 0.0, width: scrollW, height: scrollH)
    }

    private func setup() {
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.bouncesZoom = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: scrollView.frame.height)

        pagerTabView.items = ["實價登錄", "銷售中物件"]
        pagerTabView.indicatorPadding = 0.0
        pagerTabView.indicatorHieght = 4.0
        pagerTabView.setScrollView(with: scrollView)
        pagerTabView.delegate = self
        
        // Add other viewcontronller
        tradeVC.didMove(toParent: self)
        objectVC.didMove(toParent: self)
        
        typeButton.addTarget(self,
                             action: #selector(changeType(_:)),
                             for: .touchUpInside)
    }

    @objc private func changeType(_ btn: UIButton) {
        switch tradeVC.page {
        case .list:
            tradeVC.changePage(position: (25.036446116069953, 121.52975318401424))
            objectVC.changePage(position: (22.98566395872559, 120.1991662372533))
        case .map:
            tradeVC.changePage(position: nil)
            objectVC.changePage(position: nil)
        }
    }
}

extension TabSwipeDemoVC: UIPagerTabViewDelegate {
    
    func pagerTabView(pagerTabView: UIPagerTabView, didSelected index: Int) {
        tab = index == 0 ? .trade : .object
        
        let title = tab == .trade ? "訂閱最新搜尋條件" : "訂閱搜尋條件"
        subscriptionButton.setTitle(title, for: .normal)
        subscriptionButton.titleLabel?.textAlignment = .center
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(index), y: 0.0), animated: true)
    }
}
