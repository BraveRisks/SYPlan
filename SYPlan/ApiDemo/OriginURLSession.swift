//
//  OriginURLSession.swift
//  SYPlan
//
//  Created by Ray on 2019/12/19.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import Foundation

/// Use origin urlsession connect network.
class OriginURLSession: NSObject {
    
    static let share = OriginURLSession()
    
    private var session: URLSession!
    private var tasks: Dictionary<ApiRequest, URLSessionDataTask> = [:]
    
    /// 超時時間限制，value = 120
    private let timeout: TimeInterval = 30 * 4
    
    /// 等待重Call Api池，default = []
    private var apiWaitPool: [(req: ApiRequest, completion: Completion?)] = []
    
    /// 是否正在取得token中，default = false
    private var isGettingToken: Bool = false {
        didSet {
            if !isGettingToken {
                for (req, completion) in apiWaitPool {
                    req.updateHeaders(includeToken: true)
                    fetch(from: req, completion: completion)
                }
                
                apiWaitPool.removeAll()
            }
        }
    }
    
    private override init() {
        super.init()
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        config.networkServiceType = .background
        //config.httpMaximumConnectionsPerHost = 1
        //config.requestCachePolicy = .reloadIgnoringCacheData
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    public func fetch(from req: ApiRequest, completion: Completion?) {
        let reachability = try? Reachability()
        guard let r = reachability, r.isConnectedToNetwork else {
            completion?(.failure(ApiError.networkNotConnected))
            return
        }
        
        // 是否為重取Token
        let refreshToken = req.path == .taGetAuthToken
        
        // Api路徑
        var path: String
        switch req.path {
        case .taGetAuthToken:
            // 如果是`取得Token`、`記錄Log`及`註冊推播Token`，則URL為Token URL
            path = "\(tokenURL)\(req.path.rawValue)"
        default:
            path = "\(basicURL)\(req.path.rawValue)"
        }
        
        guard let url = URL(string: path) else {
            completion?(.failure(ApiError.invalidURL(msg: path)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeout
        urlRequest.httpMethod = req.method.rawValue
        urlRequest.httpBody = req.parameters?.data
        req.headers.forEach({ urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) })
        
        tasks[req]?.cancel()
        tasks.removeValue(forKey: req)
        
        #if DEBUG
        var outputParameter = req.parameters
        outputParameter?.removeValue(forKey: "PWD")
        let output = """
        🛫 API request start -------------------
        🛫 API URL       👉🏻 \(path)
        🛫 API headers   👉🏻 \(String(describing: req.headers))
        🛫 API paramters 👉🏻 \n \(String(describing: outputParameter))
        🛫 API request end   -------------------
        """
        print(output)
        #endif
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            #if DEBUG
            let code = """
            🚨 API response code 👉🏻 \(path) - \(String(describing: (response as? HTTPURLResponse)?.statusCode))
            """
            print(code)
            #endif
            
            guard let _ = (response as? HTTPURLResponse)?.statusCode else {
                if let err = error {
                    let nserror = err as NSError
                    let code = nserror.code
                    let msg = nserror.localizedDescription
                    completion?(.failure(ApiError.networkNoResponse(code: code, msg: msg)))
                } else {
                    let msg = "No any error description."
                    completion?(.failure(ApiError.networkNoResponse(code: -9999, msg: msg)))
                }
                
                return
            }
            
            if let err = error {
                let nserror = err as NSError
                let code = nserror.code
                let msg = nserror.localizedDescription
                completion?(.failure(ApiError.networkError(code: code, msg: msg)))
                return
            }
                        
            guard let data = data else {
                completion?(.failure(ApiError.nilData))
                return
            }
            
            #if DEBUG
            let output = """
            🚀 API response start -------------------
            🚀 API response path   👉🏻 \(path)
            🚀 API response result 👉🏻 \(String(describing: data.dictionary))
            🚀 API response end   -------------------
            isGettingToken = \(self.isGettingToken)
            """
            print(output)
            #endif
            
            do {
                let object = try JSONSerialization.jsonObject(with: data,
                                                              options: .mutableContainers)
                guard let dictionary = object as? JSONDictionary else {
                    completion?(.failure(ApiError.convertDictionaryFailed))
                    return
                }
                
                let status = dictionary["Status"] as? String ?? "999"
                let errDesc = dictionary["ErrDesc"] as? String ?? ""
                
                switch status {
                case "1":
                    // only for get new token
                    if refreshToken {
                        let jToken = dictionary["JToken"] as! JSONDictionary
                        let key = jToken["GKey"] as? String ?? ""
                        
                        gKey = key
                        
                        // 賦予全域變數`Agent`
                        let decoder = JSONDecoder()
                        if let data = jToken.data,
                            let user = try? decoder.decode(Agent.self, from: data) {
                            agent = user
                        }
                    }
                    
                    completion?(.success(dictionary))
                case "202", "203", "204":
                    // already login in another device
                    completion?(.failure(ApiError.forceLogout(msg: errDesc)))
                case "400":
                    // password error
                    completion?(.failure(ApiError.passwordError(msg: errDesc)))
                case "402":
                    // token invaild，refresh token
                    self.handleInvalidToken(oriReq: req, oriCompletion: completion)
                case "407":
                    // app version old，need update
                    let url = errDesc.components(separatedBy: ";")[1]
                    completion?(.failure(ApiError.appUpdate(url: url)))
                default:
                    completion?(.failure(ApiError.resultFailed(msg: errDesc)))
                }
            } catch let err {
                completion?(.failure(ApiError.parseJSONFailed(msg: err.localizedDescription)))
            }
        }
        
        tasks[req] = task
        task.resume()
    }
    
    /// 取消目前連線
    ///
    /// - Parameter req: see more ApiRequest
    public func cancel(in req: ApiRequest) {
        tasks[req]?.cancel()
        tasks.removeValue(forKey: req)
        
        print("⛔️ Cancel \(req.path)")
    }
    
    /// 取消目前所有連線
    public func cancelAll() {
        for (_, task) in tasks {
            task.cancel()
        }
        
        tasks.removeAll()
    }
    
    private func handleInvalidToken(oriReq: ApiRequest, oriCompletion: Completion?) {
        // AutoChangePassword
        // 如果無法取到KeyChain的密碼，就將`rootViewController`更改為`LoginVC`
        /*guard let _ = KeyChainManager.share.get(with: .pass) else {
            oriCompletion?(.failure(ApiError.passwordError(msg: LString("Text:PasswordError"))))
            return
        }*/
        
        // 如果正在取得Token就返回
        if isGettingToken {
            apiWaitPool.append((req: oriReq, completion: oriCompletion))
            return
        }
        
        isGettingToken = true
        
        let req = ApiRequest(method: .post, path: .taGetAuthToken,
                             parameters: ApiRequest.tokenParameters)
        fetch(from: req) { (result) in
            switch result {
            case .success(_):
                // refresh token
                oriReq.updateHeaders(includeToken: true)
                self.fetch(from: oriReq, completion: oriCompletion)
                self.isGettingToken = false
            case .failure(let err):
                oriCompletion?(.failure(err))
            }
        }
    }
    
    /// 註冊推播Token
    /*public func registerPNToken(completion: Completion?) {
        // 如果無推播Token及RealUserID，就不註冊
        guard let token = UserDefaults.getValue(for: .pnDeviceToken, type: String.self),
            let userID = UserDefaults.getValue(for: .realUserID, type: String.self) else {
            return
        }
                
        let parameters = ["UserID" : userID, "DevType": devType,
                          "APName": appName, "PnDevID": token]
        let req = ApiRequest(method: .post, path: .pnRegister, parameters: parameters)
        req.addHeader(HttpHeader.authorization)
        
        fetch(from: req, completion: completion)
    }
    
    /// 傳送使用者紀錄
    private func sendUserLog() {
        let userLogs = UserLog.shared.getUserLog()
        var userParameters = [[String: String]]()
        userLogs.forEach { (userModel) in
            userParameters.append(userModel.parseredDict)
        }
        
        print("SendUserLog count \(userParameters.count)")
        
        // 如果沒資料及RealUserID，就不送
        guard userParameters.count != 0,
            let userID = UserDefaults.getValue(for: .realUserID, type: String.self) else {
                return
        }
        
        let parameters: JSONDictionary = ["UserID": userID,
                                          "DevType": devType,
                                          "ApName": appName,
                                          "UserLat": currentLocation?.latitude ?? "",
                                          "UserLng": currentLocation?.longitude ?? "",
                                          "DataLog": userParameters]
        let req = ApiRequest(method: .post, path: .taSetAppLog, parameters: parameters)
        req.addHeader(HttpHeader.authorization)

        fetch(from: req) { (result) in
            switch result {
            case .success(_):
                UserLog.shared.clearAll()
            case .failure(_): break
            }
        }
    }*/
}

extension OriginURLSession: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // do nothing
    }
    
    // Send Data
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        print("URLSessionDownloadDelegate didSendBodyData 👉🏻 \(bytesSent)")
//        print("URLSessionDownloadDelegate totalBytesSent 👉🏻 \(totalBytesSent)")
//        print("URLSessionDownloadDelegate totalBytesExpectedToSend 👉🏻 \(totalBytesExpectedToSend)")
    }
    
    // Download Data
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        //print("URLSessionDownloadDelegate didWriteData 👉🏻 \(bytesWritten)")
        //print("URLSessionDownloadDelegate totalBytesWritten 👉🏻 \(totalBytesWritten)")
        //print("URLSessionDownloadDelegate totalBytesExpectedToWrite 👉🏻 \(totalBytesExpectedToWrite)")
    }
}
