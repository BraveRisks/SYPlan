//
//  WebViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/10/16.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    private let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height

    private var fbWebView: UIFBWebView!
    private var origin: CGPoint = .zero
    private var velocityThreshold: CGFloat = 3600.0
    private var originYThreshold: CGFloat = 530.0
    
    // 用來判斷是否滾動至頂部
    private var isScrollToTap: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        print("viewSafeAreaInsetsDidChange")
    }
    
    override func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            print("Top --> \(view.safeAreaInsets.top)")
        }
        origin = fbWebView.frame.origin
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fbWebView.url = "https://www.mobile01.com/"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("WebView viewDidDisappear")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        view.backgroundColor = UIColor(hex: "000000", alpha: 0.6)
        
        fbWebView = UIFBWebView()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        pan.delegate = self
        fbWebView.addGestureRecognizer(pan)
        fbWebView.delegate = self
        fbWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fbWebView)
        NSLayoutConstraint.activate([
            fbWebView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight),
            fbWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            fbWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            fbWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
    }
    
    @objc private func panAction(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began || pan.state == .changed {
            let translation = pan.translation(in: view)
            // note: 'view' is optional and need to be unwrapped
            let x = pan.view!.center.x //+ translation.x
            let y = pan.view!.center.y + translation.y
            pan.view!.center = CGPoint(x: x, y: y)
            pan.setTranslation(.zero, in: view)
        } else if pan.state == .ended {
            let velocity = pan.velocity(in: view)
            let origin = fbWebView.frame.origin
            //print("panAction End velocity --> \(velocity)")
            //print("panAction fbWebView origin --> \(origin)")
            if velocity.y > velocityThreshold || origin.y > originYThreshold {
                dismissAfterAminate()
                return
            }
            
            if origin.y > self.origin.y || origin.y < self.origin.y {
                scrollToOriginal()
            }
        }
    }
    
    private func scrollToOriginal() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.fbWebView.frame.origin = self.origin
        }, completion: nil)
    }
    
    private func dismissAfterAminate() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor(hex: "000000", alpha: 0.0)
            self.fbWebView.frame.origin.y = self.view.frame.height
        }) { (end) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
extension WebViewController: UIFBWebViewDelegate {
    func webViewDidClose(webView: UIFBWebView) {
        dismissAfterAminate()
    }
    
    func webViewDidShare(webView: UIFBWebView) {
        
    }
}

extension WebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let pan = gestureRecognizer as? UIPanGestureRecognizer, pan.state == .began {
            let translationY = pan.translation(in: pan.view).y
            //print("pan --> \(translationY)")
            if let view = otherGestureRecognizer.view, let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = !(translationY > 0.0 && isScrollToTap)
                scrollView.delegate = self
            }
            return translationY > 0.0 && isScrollToTap
        }
        return false
    }
}

extension WebViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrollToTap = scrollView.contentOffset.y == 0.0
    }
}
