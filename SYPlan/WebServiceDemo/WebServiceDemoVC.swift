//
//  WebServiceDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2019/4/29.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit

class WebServiceDemoVC: UIViewController {

    @IBOutlet weak var mTokenLab: UILabel!
    @IBOutlet weak var mTokenBtn: UIButton!
    @IBOutlet weak var mLoginLab: UILabel!
    @IBOutlet weak var mLoginBtn: UIButton!
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3.0
        configuration.timeoutIntervalForResource = 10.0
        return URLSession(configuration: configuration)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        mTokenBtn.addTarget(self, action: #selector(getToken(_:)), for: .touchUpInside)
        mLoginBtn.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
    }
    
    @objc private func getToken(_ btn: UIButton) {
        var req = WebApiRequest(method: .post, soapName: .ssIphoneRegister)
        req.headers = [HttpHeader.xml]

        WebApiManager.fetch(from: req, with: .login(user: "384861", pass: "zxcvbnm")) {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    self.mTokenLab.text = json["gKey"] as? String
                case .failure(let error):
                    self.mTokenLab.text = "\(error.message)"
                }
            }
        }
    }
    
    @objc private func login(_ btn: UIButton) {
        var req: WebApiRequest = WebApiRequest(method: .post, soapName: .sinyiEmployeeInfo)
        req.headers = [HttpHeader.xml]
        
        let param: JSON = [
            "UserID": "384861",
            "DeviceType": "1",
            "DeviceOS": "10.3"
        ]
        
        webGKey = "464d36a6-b616-4cce-a4a3-cdc17a54cb04"
        
        WebApiManager.fetch(from: req, with: .other(param: param, extParam: nil)) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    self.mLoginLab.text = json.string
                case .failure(let error):
                    self.mLoginLab.text = "\(error.message)"
                }
            }
        }
    }
}
