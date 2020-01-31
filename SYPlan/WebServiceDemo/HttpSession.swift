//
//  HttpSession.swift
//  SYPlan
//
//  Created by Ray on 2019/5/16.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import Foundation

/// Use origin urlsession connect network.
class HttpSession: NSObject {
    static let share = HttpSession()
    
    private var session: URLSession
    private var tasks: Dictionary<WebApiRequest, URLSessionDataTask>
    
    private override init() {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 15
        config.networkServiceType = .background
        config.httpMaximumConnectionsPerHost = 1
        //config.requestCachePolicy = .reloadIgnoringCacheData
        session = URLSession(configuration: config)
        tasks = [:]
    }
    
    public func fetch(from req: WebApiRequest, with param: SoapParameters, completion: @escaping WebCompletion) {
        let reachability = try? Reachability()
        guard let r = reachability, r.isConnectedToNetwork else {
            completion(.failure(WebApiError.networkError))
            return
        }
        
        guard let url = URL(string: basePath) else {
            completion(.failure(WebApiError.invalidURL(url: basePath)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = req.method.rawValue
        req.headers?.forEach({ urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) })
        urlRequest.httpBody = req.soapName.data(param: param)
        
        tasks[req]?.cancel()
        currentSoapName = req.soapName
        
        #if DEBUG
        let output = """
        API request start -------------------
        API URL       👉🏻 \(basePath)
        API headers   👉🏻 \(String(describing: req.headers))
        API paramters 👉🏻 \n\(String(data: req.soapName.data(param: param)!, encoding: .utf8)!)
        API request end   -------------------
        """
        print(output)
        #endif
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                completion(.failure(WebApiError.other(msg: err.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(WebApiError.nilData))
                return
            }
            
            #if DEBUG
            let output = """
            API response start -------------------
            API result 👉🏻 \(String(describing: data.dictionary?.debugDescription))
            API response end   -------------------
            """
            print(output)
            #endif
            
            // 解析XML
            let xmlParser = XMLParser(data: data)
            xmlParser.delegate = self
            let success = xmlParser.parse()
            
            if success {
                if let code = Int(currentXMLResult.prefix(3)), code != 200 {
                    // 20190514 Tue webservice不會回token失效，是回錯誤碼：300
                    // Token Failed 402
                    if code == 300 {
                        self.handleInvalidToken(oriReq: req, oriParam: param, oriCompletion: completion)
                        return
                    }
                    
                    let url = String(currentXMLResult.dropFirst(3))
                    let error: WebApiError = code == 407 ? .appUpdate(url: url) : .resultFailed(code: code)
                    completion(.failure(error))
                    return
                }
                
                switch currentSoapName {
                case .ssIphoneRegister:
                    webGKey = String(currentXMLResult.dropFirst(3))
                    let res = response as! HTTPURLResponse
                    
                    var json: JSON = [:]
                    json["statusCode"] = res.statusCode
                    json["gKey"] = webGKey
                    completion(.success(json))
                case .sinyiEmployeeInfo, .sinyiAppStoreList:
                    completion(.success(currentXMLResult.dictionary))
                }
            } else {
                completion(.failure(WebApiError.parseXMLFailed))
            }
            
            // remove this request
            self.tasks.removeValue(forKey: req)
        }
        
        task.resume()
        tasks[req] = task
    }
    
    private func handleInvalidToken(oriReq: WebApiRequest, oriParam: SoapParameters,
                                    oriCompletion: @escaping WebCompletion) {
        var req = WebApiRequest(method: .post, soapName: .ssIphoneRegister)
        req.headers = [HttpHeader.xml]
        
        fetch(from: req, with: .login(user: "384861", pass: "1qaz2wsx")) { (result) in
            // success or failure , always do fetch get token until get success.
            self.fetch(from: oriReq, with: oriParam, completion: oriCompletion)
        }
    }
}

extension HttpSession: XMLParserDelegate {
    // step 1.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentXMLResult = ""
    }
    
    // step 2.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentXMLResult += string
    }
    
    // step 3.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // do nothing
    }
}
