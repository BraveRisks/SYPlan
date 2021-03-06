//
//  UIPagerTabView.swift
//  SYPlan
//
//  Created by Ray on 2018/11/28.
//  Copyright © 2018年 Sinyi. All rights reserved.
//  Swift version 4.1

import UIKit

protocol UIPagerTabViewDelegate: class {
    func pagerTabView(pagerTabView: UIPagerTabView, didSelected index: Int)
}

/// UIPagerTabView(Tab指示器)
/// ```
/// How to use ?
/// let pagerTabView = UIPagerTabView(frame: .zero)
/// pagerTabView.items = ["Swift", "Kotlin", "JavaScript"]
/// pagerTabView.translatesAutoresizingMaskIntoConstraints = false
/// view.addSubview(pagerTabView)
/// NSLayoutConstraint.activate([
///    pagerTabView.topAnchor.constraint(equalTo: view.topAnchor),
///    pagerTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
///    pagerTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
///    pagerTabView.heightAnchor.constraint(equalToConstant: 50.0)
/// ])
///
/// If u want to with UIScrollView, then u need add this method.
/// pagerTabView.setScrollView(with: Your UIScrollView)
/// ```
class UIPagerTabView: UIView {
    
    private var scrollView: UIScrollView!
    private var lineView: UIView!
    
    private var lineViewLeadingConstraint: NSLayoutConstraint!
    
    /// Indicator width
    private var lineViewWidthConstraint: NSLayoutConstraint!
    
    /// Indicator height
    private var lineViewHeightConstraint: NSLayoutConstraint!
    
    /// 指示名稱
    var items: [String] = [] {
        didSet {
            // 3
            print("init items")
            addButton()
        }
    }
    
    /// item的字型 default：UIFont.systemFont(ofSize: 16.0, weight: .medium)
    var itemFont: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .medium) {
        didSet { changeFont() }
    }
    
    /// item的顏色 default：#4d4d4d
    var itemColor: UIColor = UIColor(red: 0.301, green: 0.301, blue: 0.301, alpha: 0.301) {
        didSet { changeColor(isTint: false) }
    }
    
    /// item高亮的顏色 default：#3366ff
    var itemTintColor: UIColor = UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0) {
        didSet { changeColor(isTint: true) }
    }
    
    /// 指示條的高度 default：2.0
    var indicatorHieght: CGFloat = 2.0 {
        didSet { lineViewHeightConstraint.constant = indicatorHieght }
    }
    
    /// 指示條距離左右的間距 default：20.0
    var indicatorPadding: CGFloat = 20.0 {
        didSet {
            lineViewLeadingConstraint.isActive = false
            lineViewLeadingConstraint = lineView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                                          constant: indicatorPadding)
            lineViewLeadingConstraint.isActive = true
        }
    }
    
    /// 目前的位置
    var currentIndex: Int = 0
    
    weak var delegate: UIPagerTabViewDelegate?
    
    /// 是否固定寬度(目前保留)
    private var isFixed: Bool = true
    
    /// 目前滑動的方式，是否透過點擊自行滑動
    private var isScrollByClick = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 1
        print("init frame")
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 1
        print("init coder")
        setup()
    }
    
    override func layoutSubviews() {
        // 4
        print("init layoutSubviews --> \(frame)")
        if frame != .zero && items.count > 0 {
            addButton()
        }
    }
    
    private func setup() {
        // 2
        print("init setup")
        scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        scrollView.topAnchor
                  .constraint(equalTo: topAnchor)
                  .isActive = true
        scrollView.leadingAnchor
                  .constraint(equalTo: leadingAnchor)
                  .isActive = true
        scrollView.trailingAnchor
                  .constraint(equalTo: trailingAnchor)
                  .isActive = true
        scrollView.bottomAnchor
                  .constraint(equalTo: bottomAnchor)
                  .isActive = true

        lineView = UIView(frame: .zero)
        lineView.backgroundColor = itemTintColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        lineViewLeadingConstraint = lineView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                                      constant: indicatorPadding)
        lineViewLeadingConstraint.isActive = true
        
        lineViewWidthConstraint = lineView.widthAnchor.constraint(equalToConstant: 0.0)
        lineViewWidthConstraint.isActive = true
        
        lineViewHeightConstraint = lineView.heightAnchor.constraint(equalToConstant: indicatorHieght)
        lineViewHeightConstraint.isActive = true
        
        lineView.bottomAnchor
                .constraint(equalTo: bottomAnchor)
                .isActive = true
    }
    
    private func addButton() {
        let width = frame.width
        let height = frame.height
        let count = items.count
        
        if count <= 0 { return }
        
        // 如果已有新增，則將之前的給移除
        if scrollView.subviews.count > 0 {
            scrollView.subviews.forEach { (view) in
                if view is UIButton { view.removeFromSuperview() }
            }
        }
        
        // 設定Indicator width
        let linwViewWidth = width / CGFloat(count) - (indicatorPadding * 2)
        lineViewWidthConstraint.constant = linwViewWidth < 0 ? 0.0 : linwViewWidth
        
        var btnX: CGFloat = 0.0
        let btnY: CGFloat = 0.0
        let btnW: CGFloat = width / CGFloat(count)
        let btnH: CGFloat = height
        for i in 0 ..< count {
            btnX = btnW * CGFloat(i)
            let btn = createButton(items[i])
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            btn.setTitleColor(i == currentIndex ? itemTintColor : itemColor, for: .normal)
            btn.tag = i
            scrollView.addSubview(btn)
        }
        
        let contentSize = CGSize(width: width, height: btnH)
        scrollView.contentSize = contentSize
    }
    
    private func createButton(_ title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = itemFont
        btn.addTarget(self, action: #selector(didClicked(with:)), for: .touchUpInside)
        return btn
    }
    
    private func changeColor(isTint: Bool) {
        scrollView.subviews.forEach { (view) in
            if let btn = view as? UIButton {
                btn.setTitleColor(btn.tag == currentIndex ? itemTintColor : itemColor, for: .normal)
            }
        }
        
        if isTint {
            lineView.backgroundColor = itemTintColor
        }
    }
    
    private func changeFont() {
        scrollView.subviews.forEach { (view) in
            if let btn = view as? UIButton {
                btn.titleLabel?.font = itemFont
            }
        }
    }
    
    @objc private func didClicked(with button: UIButton) {
        let tag = button.tag
        currentIndex = tag
        changeColor(isTint: false)
        
        let width = button.frame.width
        let originY = lineView.frame.minY
        let x = width * CGFloat(tag) + indicatorPadding
        isScrollByClick = true
        UIView.animate(withDuration: 0.2) {
            self.lineView.frame.origin = CGPoint(x: x, y: originY)
        }
        
        delegate?.pagerTabView(pagerTabView: self, didSelected: tag)
    }
    
    /// 設置連動的UIScrollView
    ///
    /// - Parameter scrollView: scrollView
    public func setScrollView(with scrollView: UIScrollView) {
        scrollView.delegate = self
    }
}

extension UIPagerTabView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrollByClick { return }
        
        // 先計算indicator的寬度
        let columnW = frame.width / CGFloat(items.count)
        
        // 再計算scrollView寬度 對應 indicator寬度 的比例
        let scale = scrollView.frame.width / columnW
        
        // 再換算scrollView移動時，所對應indicator的距離
        let offsetX = scrollView.contentOffset.x / scale
        let originY = lineView.frame.minY
        lineView.frame.origin = CGPoint(x: offsetX + indicatorPadding, y: originY)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / frame.width)
        currentIndex = index
        changeColor(isTint: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollByClick = false
    }
}
