//
//  PDFVC.swift
//  SYPlan
//
//  Created by Ray on 2020/2/13.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//  開啟PDF

import UIKit
import WebKit

class PDFVC: UIViewController {

    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addWatermark()
    }
    
    private func setup() {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        let url = URL(string: "http://api.sinyi.com.tw/JServer/TAPridoc/ReceptionCloud/9215D093-0C84-4878-88C2-5A604BB71B48.pdf")!
        webView?.load(URLRequest(url: url))
        webView?.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(webView!)
        webView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
