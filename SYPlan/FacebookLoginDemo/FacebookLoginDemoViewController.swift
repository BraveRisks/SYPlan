//
//  FacebookLoginDemoViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/7/4.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class FacebookLoginDemoViewController: UIViewController {

    enum FBStatus: String {
        case login = "Facebook is login"
        case logout = "Facebook is logout"
        case none = "none"
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    private let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _ = AccessToken.current else { return }
        requestProfile()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        statusLabel.text = FBStatus.none.rawValue
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
    }
    
    private func loadData(from parameters: Dictionary<String, Any>) {
        let id = parameters["id"] as? String ?? ""
        let name = parameters["name"] as? String ?? ""
        let email = parameters["email"] as? String ?? ""
        statusLabel.text = FBStatus.login.rawValue
        idLabel.text = "ID 👉🏻 \(id)"
        nameLabel.text = "Name 👉🏻 \(name)"
        emailLabel.text = "Email 👉🏻 \(email)"
    }
    
    private func reset() {
        statusLabel.text = FBStatus.logout.rawValue
        idLabel.text = "ID 👉🏻"
        nameLabel.text = "Name 👉🏻"
        emailLabel.text = "Email 👉🏻"
    }
    
    private func requestProfile() {
        let parameters = ["fields": "id, name, email, picture"]
        let request = GraphRequest(graphPath: "/me", parameters: parameters, httpMethod: .get)
        request.start { (connection, result, error) in
            print("Graph Request statusCode: \(String(describing: connection?.urlResponse?.statusCode))")
            
            switch (result, error) {
            case let (result?, nil):
                if let dictionary = result as? Dictionary<String, Any> {
                    self.loadData(from: dictionary)
                    print("Graph Request Succeeded: \(dictionary)")
                }
            case let (nil, error?):
                print("Graph Request Failed: \(error)")
            case (_, _):
                print("Graph Request Failed: unknown error")
            }
        }
    }
    
    @objc private func login() {
        if let _ = AccessToken.current { return }
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .failed(let error):
                print("Facebook Login error 👉🏻 \(error.localizedDescription)")
            case .cancelled:
                print("Facebook Login cancelled.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.requestProfile()
                print("Facebook Login success. \(accessToken.tokenString)")
            }
        }
    }
    
    @objc private func logout(_ btn: UIButton) {
        guard AccessToken.current != nil else { return }
        loginManager.logOut()
        reset()
    }
}
