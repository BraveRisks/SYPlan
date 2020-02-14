//
//  UIFBWebView.swift
//  SYPlan
//
//  Created by Ray on 2018/10/18.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit
import WebKit

protocol UIFBWebViewDelegate: class {
    func webViewDidClose(webView: UIFBWebView)
    
    func webViewDidShare(webView: UIFBWebView)
}

class UIFBWebView: UIView {
    private var mProgressView: UIWebProgressView!
    private var mPrevBtn: UIButton!
    private var mNextBtn: UIButton!
    private var mTitleLab: UILabel!
    private var mTitleBtn: UIButton!
    private var mContainerView: UIView!
    private var mWebView: WKWebView!
    
    private let largeWH: CGFloat = 26.0
    private let smallWH: CGFloat = 22.0
    private var estimatedProgressObserver: NSKeyValueObservation?
    private var webTitleObserver: NSKeyValueObservation?
    
    var url: String? {
        didSet {
            //mTitleLab.text = url
            mTitleBtn.setTitle(url, for: .normal)
            if url == nil { return }
            mWebView.load(URLRequest(url: URL(string: url!)!))
            
            // WKWebView progress KVO
            // http://pkuflint.me/2018/understanding-kvo-in-swift/
            estimatedProgressObserver = mWebView.observe(\.estimatedProgress, options: [.new, .old], changeHandler: { [weak self] (webView, value) in
                //print("webView progress --> \(webView.estimatedProgress)")
                self?.mProgressView.progress = CGFloat(webView.estimatedProgress)
                if webView.estimatedProgress == 1.0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self?.mProgressView.progressColor = .white
                    })
                }
            })
            
            webTitleObserver = mWebView.observe(\.title, options: [.new, .old], changeHandler: { [weak self] (webView, value) in
                //self?.mTitleLab.text = webView.title
                self?.mTitleBtn.setTitle(webView.title, for: .normal)
            })
        }
    }
    
    weak var delegate: UIFBWebViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == CGRect.zero { return }
        setup()
    }
    
    convenience init(url: String) {
        self.init(frame: CGRect.zero)
        self.url = url
    }
    
    override func layoutSubviews() {
        if frame.width == 0 || frame.height == 0 { return }
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        mWebView.stopLoading()
        estimatedProgressObserver?.invalidate()
    }
    
    private func setup() {
        print("UIFBWebView setup")
        /*
         View Position
         ----------------- mIndicatorView ------------------
         ---------------------------------------------------
         |--------------- mWebProgressView ----------------|
         |mCloseBtn  mPrevBtn mTitleLab mNextBtn  mShareBtn|
         |------------------- mLineView -------------------|
         ------------------ containerView ------------------
         -------------------- mWebView ---------------------
         */
        let mIndicatorView = UIView()
        mIndicatorView.layer.cornerRadius = 3.0
        mIndicatorView.backgroundColor = UIColor(hex: "cfcfcf")
        mIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mIndicatorView)
        NSLayoutConstraint.activate([
            mIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            mIndicatorView.heightAnchor.constraint(equalToConstant: 6.0),
            mIndicatorView.widthAnchor.constraint(equalToConstant: 60.0),
            mIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0)
        ])
        
        mContainerView = UIView()
        mContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mContainerView)
        NSLayoutConstraint.activate([
            mContainerView.topAnchor.constraint(equalTo: mIndicatorView.bottomAnchor, constant: 10.0),
            mContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            mContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            mContainerView.heightAnchor.constraint(equalToConstant: 46.0)
        ])
        
        mProgressView = UIWebProgressView()
        mProgressView.translatesAutoresizingMaskIntoConstraints = false
        mContainerView.addSubview(mProgressView)
        NSLayoutConstraint.activate([
            mProgressView.topAnchor.constraint(equalTo: mContainerView.topAnchor, constant: 0.0),
            mProgressView.leadingAnchor.constraint(equalTo: mContainerView.leadingAnchor, constant: 0.0),
            mProgressView.trailingAnchor.constraint(equalTo: mContainerView.trailingAnchor, constant: 0.0),
            mProgressView.bottomAnchor.constraint(equalTo: mContainerView.bottomAnchor, constant: 0.0)
        ])
        
        let mCloseBtn = UIButton(type: .system)
        mCloseBtn.setImage(UIImage(named: "web_close"), for: .normal)
        mCloseBtn.tintColor = .gray
        mCloseBtn.translatesAutoresizingMaskIntoConstraints = false
        mContainerView.addSubview(mCloseBtn)
        NSLayoutConstraint.activate([
            mCloseBtn.widthAnchor.constraint(equalToConstant: largeWH),
            mCloseBtn.heightAnchor.constraint(equalToConstant: largeWH),
            mCloseBtn.topAnchor.constraint(equalTo: mContainerView.topAnchor, constant: 10.0),
            mCloseBtn.leadingAnchor.constraint(equalTo: mContainerView.leadingAnchor, constant: 10.0)
        ])
        
        let mShareBtn = UIButton(type: .system)
        mShareBtn.setImage(UIImage(named: "web_share"), for: .normal)
        mShareBtn.tintColor = .gray
        mShareBtn.translatesAutoresizingMaskIntoConstraints = false
        mContainerView.addSubview(mShareBtn)
        NSLayoutConstraint.activate([
            mShareBtn.widthAnchor.constraint(equalToConstant: largeWH),
            mShareBtn.heightAnchor.constraint(equalToConstant: largeWH),
            mShareBtn.topAnchor.constraint(equalTo: mContainerView.topAnchor, constant: 10.0),
            mShareBtn.trailingAnchor.constraint(equalTo: mContainerView.trailingAnchor, constant: -10.0)
        ])
        
        mPrevBtn = UIButton(type: .system)
        mPrevBtn.setImage(UIImage(named: "web_prev"), for: .normal)
        mPrevBtn.tintColor = .gray
        mPrevBtn.isEnabled = false
        mPrevBtn.translatesAutoresizingMaskIntoConstraints = false
        mContainerView.addSubview(mPrevBtn)
        NSLayoutConstraint.activate([
            mPrevBtn.widthAnchor.constraint(equalToConstant: smallWH),
            mPrevBtn.heightAnchor.constraint(equalToConstant: smallWH),
            mPrevBtn.centerYAnchor.constraint(equalTo: mCloseBtn.centerYAnchor, constant: 0.0),
            mPrevBtn.leadingAnchor.constraint(equalTo: mCloseBtn.trailingAnchor, constant: 15.0)
        ])
        
        mNextBtn = UIButton(type: .system)
        mNextBtn.setImage(UIImage(named: "web_next"), for: .normal)
        mNextBtn.tintColor = .gray
        mNextBtn.isEnabled = false
        mNextBtn.translatesAutoresizingMaskIntoConstraints = false
        mContainerView.addSubview(mNextBtn)
        NSLayoutConstraint.activate([
            mNextBtn.widthAnchor.constraint(equalToConstant: smallWH),
            mNextBtn.heightAnchor.constraint(equalToConstant: smallWH),
            mNextBtn.centerYAnchor.constraint(equalTo: mShareBtn.centerYAnchor, constant: 0.0),
            mNextBtn.trailingAnchor.constraint(equalTo: mShareBtn.leadingAnchor, constant: -15.0)
        ])
        
//        mTitleLab = UILabel()
//        mTitleLab.font = UIFont.boldSystemFont(ofSize: 16.0)
//        mTitleLab.lineBreakMode = .byClipping
//        mTitleLab.textColor = UIColor(hex: "17a21a")
//        mTitleLab.textAlignment = .center
//        mTitleLab.translatesAutoresizingMaskIntoConstraints = false
//        mContainerView.addSubview(mTitleLab)
//        NSLayoutConstraint.activate([
//            mTitleLab.heightAnchor.constraint(equalToConstant: smallWH),
//            mTitleLab.centerYAnchor.constraint(equalTo: mShareBtn.centerYAnchor, constant: 0.0),
//            mTitleLab.leadingAnchor.constraint(equalTo: mPrevBtn.trailingAnchor, constant: 10.0),
//            mTitleLab.trailingAnchor.constraint(equalTo: mNextBtn.leadingAnchor, constant: -10.0)
//        ])
        
        mTitleBtn = UIButton(type: .system)
        mTitleBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        mTitleBtn.titleLabel?.lineBreakMode = .byClipping
        mTitleBtn.titleLabel?.textAlignment = .center
        mTitleBtn.setTitleColor(UIColor(hex: "17a21a"), for: .normal)
        mTitleBtn.tintColor = UIColor(hex: "17a21a")
        mTitleBtn.translatesAutoresizingMaskIntoConstraints = false
        mContainerView.addSubview(mTitleBtn)
        NSLayoutConstraint.activate([
            mTitleBtn.heightAnchor.constraint(equalToConstant: smallWH),
            mTitleBtn.centerYAnchor.constraint(equalTo: mShareBtn.centerYAnchor, constant: 0.0),
            mTitleBtn.leadingAnchor.constraint(equalTo: mPrevBtn.trailingAnchor, constant: 10.0),
            mTitleBtn.trailingAnchor.constraint(equalTo: mNextBtn.leadingAnchor, constant: -10.0)
        ])
        
        let mLineView = UIView()
        mLineView.backgroundColor = UIColor(hex: "c6c6c6")
        mLineView.translatesAutoresizingMaskIntoConstraints = false
        mContainerView.addSubview(mLineView)
        NSLayoutConstraint.activate([
            mLineView.heightAnchor.constraint(equalToConstant: 0.5),
            mLineView.bottomAnchor.constraint(equalTo: mContainerView.bottomAnchor, constant: 0.0),
            mLineView.leadingAnchor.constraint(equalTo: mContainerView.leadingAnchor, constant: 0.0),
            mLineView.trailingAnchor.constraint(equalTo: mContainerView.trailingAnchor, constant: 0.0)
        ])
        
        let config = WKWebViewConfiguration()
        mWebView = WKWebView(frame: CGRect.zero, configuration: config)
        mWebView.navigationDelegate = self
        mWebView.uiDelegate = self
        mWebView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mWebView)
        NSLayoutConstraint.activate([
            mWebView.topAnchor.constraint(equalTo: mContainerView.bottomAnchor, constant: 0.0),
            mWebView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            mWebView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            mWebView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
        ])
        
        mCloseBtn.addTarget(self, action: #selector(onClose(_:)), for: .touchUpInside)
        mShareBtn.addTarget(self, action: #selector(onShare(_:)), for: .touchUpInside)
        mPrevBtn.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
        mNextBtn.addTarget(self, action: #selector(goForward(_:)), for: .touchUpInside)
    }
    
    private func setTitleBtnImage(_ url: String) {
        if url.hasPrefix("https") {
            mTitleBtn.setImage(UIImage(named: "web_lock"), for: .normal)
        }
    }
    
    @objc private func onClose(_ btn: UIButton) {
        delegate?.webViewDidClose(webView: self)
    }
    
    @objc private func onShare(_ btn: UIButton) {
        delegate?.webViewDidShare(webView: self)
    }
    
    @objc private func goForward(_ btn: UIButton) {
        mWebView.goForward()
    }
    
    @objc private func goBack(_ btn: UIButton) {
        mWebView.goBack()
    }
    
    private class UIWebProgressView: UIView {
        private let radius: CGFloat = 10.0
        private let arc180: CGFloat = .pi
        private let arc270: CGFloat = 3 * .pi / 2
        private let arc360: CGFloat = 2 * .pi
        
        var progress: CGFloat = 0.0 {
            didSet { setNeedsDisplay() }
        }
        
        var progressColor: UIColor = UIColor(hex: "f2f2f2") {
            didSet { setNeedsDisplay() }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            // Use layer mask
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = rect
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
            
            let progressPath = UIBezierPath()
            progressPath.lineWidth = 1.0
            progressPath.move(to: CGPoint(x: 0.0, y: 0.0))
            progressPath.addLine(to: CGPoint(x: rect.width * progress, y: 0.0))
            progressPath.addLine(to: CGPoint(x: rect.width * progress, y: rect.height))
            progressPath.addLine(to: CGPoint(x: 0.0, y: rect.height))
            progressPath.close()
            progressColor.setFill()
            progressPath.fill()
            
            // Use Arc
            /*let progressPath = UIBezierPath()
             progressPath.lineWidth = 1.0
             progressPath.move(to: CGPoint(x: 0.0, y: 0.0))
             progressPath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: arc180, endAngle: arc270, clockwise: true)
             let w = rect.width * progress
             progressPath.addLine(to: CGPoint(x: progress == 1.0 ? w - radius : w * progress, y: 0.0))
             if progress == 1.0 {
             progressPath.addArc(withCenter: CGPoint(x: w - radius, y: radius), radius: radius, startAngle: arc270, endAngle: arc360, clockwise: true)
             }
             progressPath.addLine(to: CGPoint(x: w, y: rect.height))
             progressPath.addLine(to: CGPoint(x: 0.0, y: rect.height))
             progressPath.close()
             UIColor.blue.setFill()
             progressPath.fill()*/
        }
    }
}
extension UIFBWebView: WKNavigationDelegate {
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("webView webViewWebContentProcessDidTerminate")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 1 準備開始載入網頁
        if let url = webView.url {
            //mTitleLab.text = url.absoluteString
            mTitleBtn.setTitle(url.absoluteString, for: .normal)
            setTitleBtnImage(url.absoluteString)
        }
        mProgressView.progress = 0.0
        mProgressView.progressColor = UIColor(hex: "f2f2f2")
        print("webView didStartProvisionalNavigation navigation")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // 2 網頁載入中
        print("webView didCommit navigation")
        mPrevBtn.isEnabled = webView.canGoBack
        mNextBtn.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 3 網頁載入完畢
        print("webView didFinish navigation")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 網頁載入時，發生錯誤
        print("webView didFail navigation")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // 當網頁有重新導向時，會調用該方法
        print("webView didReceiveServerRedirectForProvisionalNavigation navigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //
        print("webView didFailProvisionalNavigation navigation")
    }
}

extension UIFBWebView: WKUIDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        print("webView webViewDidClose")
    }
}
