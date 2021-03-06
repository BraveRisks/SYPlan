//
//  ApiManager.swift
//  SYPlan
//
//  Created by Ray on 2019/12/19.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import Foundation

/// Api callback `completion`
typealias Completion = (Result<JSONDictionary, ApiError>) -> Swift.Void

typealias JSONDictionary = Dictionary<String, Any>

// 測試機
let basicURL: String = "http://apiv2test.sinyi.com.tw/api/TA2/"
let tokenURL: String = "http://apiv2test.sinyi.com.tw/api/TA2Token/"

/// 使用者Model，default = nil
var agent: Agent?

/// 記錄目前的Token，default：""
var gKey: String = ""

enum ApiError: Error {
    
    /// 網路未連接
    case networkNotConnected
    
    /// 無效的網址
    case invalidURL(msg: String)
    
    /// 網路請求無回應碼
    case networkNoResponse(code: Int, msg: String)
    
    /// 網路發生錯誤
    case networkError(code: Int, msg: String)
    
    /// 回傳資料為空值
    case nilData
    
    /// 轉換Dictionary失敗
    case convertDictionaryFailed
    
    /// 解析JSON格式失敗
    case parseJSONFailed(msg: String)
    
    case resultFailed(msg: String)
    
    case forceLogout(msg: String)
    
    case passwordError(msg: String)
    
    case appUpdate(url: String)
    
    case other(msg: String)
    
    var message: String {
        switch self {
        case .networkNotConnected: return "網路未連接"
        case .invalidURL(let msg): return "無效的網址 \(msg)"
        case .networkNoResponse(let code, let msg):
            return "網路請求無回應\n錯誤碼：\(code)\n描述：\(msg)"
        case .networkError(let code, let msg):
            return "網路請求錯誤\n錯誤碼：\(code)\n描述：\(msg)"
        case .nilData: return "回傳資料為空值"
        case .convertDictionaryFailed: return "轉換Dictionary失敗"
        case .parseJSONFailed(let msg): return "解析JSON格式錯誤\n描述：\(msg)"
        case .resultFailed(let msg): return msg
        case .forceLogout(_): return "裝置已被其他帳號綁定"
        case .passwordError(let msg): return msg
        case .appUpdate(_): return "軟體更新"
        case .other(let msg): return msg
        }
    }
}

/// HTTP header
enum HttpHeader {
    
    case xml
    
    case json
    
    case authorization
    
    var field: String {
        switch self {
        case .xml, .json:
            return "Content-Type"
        case .authorization:
            return "Authorization"
        }
    }
    
    var value: String {
        switch self {
        case .xml:
            return "text/xml; charset=utf-8"
        case .json:
            return "application/json"
        case .authorization:
            return "Bearer \(gKey)"
        }
    }
}

/// HTTP Connect method
///
/// - get: GET
/// - post: POST
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

/// Http Request
public class ApiRequest: Hashable, Equatable, CustomStringConvertible {
    
    var method: HttpMethod
    
    var path: ApiPath
    
    var parameters: JSONDictionary?
    
    private(set) var headers: [HttpHeader]
    
    public var description: String {
        let msg = """
        ApiRequest Start -----------
        method     👉🏻 \(method)
        headers    👉🏻 \(headers)
        path       👉🏻 \(path)
        parameters 👉🏻 \(String(describing: parameters))
        ApiRequest End  -----------
        """
        return msg
    }
    
    /// Refresh Token parameters
    class var tokenParameters: JSONDictionary {
        let parameters =  [
            "UserID"   : "384861",
            "PWD"      : "poiuytrewq",
            "DevType"  : "2",
            "OSVer"    : "13.2.2",
            "ApVer"    : "1.0.34",
            "MobileId" : "iPhone 11 Pro",
            "APName"   : "TA2",
            "DevNewHID": "554543bc7d8e409db3d6a600343ec06a"
        ]
        return parameters
    }
    
    init(method: HttpMethod, path: ApiPath, parameters: JSONDictionary = [:]) {
        self.method = method
        self.path = path
        self.parameters = parameters
        headers = [.json]
        
        // 如果不是重取Token，就帶入共用參數及Token
        if path != .taGetAuthToken {
            // add token
            addHeader(.authorization)
            
            // add common parameters
            self.parameters?["UserID"] = "225315"
            self.parameters?["DevType"] = "2"
            self.parameters?["ApName"] = "TA2"
            self.parameters?["APName"] = "TA2"
            self.parameters?["UserLat"] = 25.032663
            self.parameters?["UserLng"] = 121.565810
        }
    }
    
    func addHeader(_ header: HttpHeader) {
        headers.append(header)
    }
    
    /// 更新Request Http heades
    /// - paramster: include：是否更新token，default：false
    public func updateHeaders(includeToken: Bool = false) {
        headers.removeAll()
        headers.append(HttpHeader.json)
        if includeToken { headers.append(.authorization) }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(method)
        hasher.combine(path)
        if let p = parameters {
            hasher.combine(NSDictionary(dictionary: p))
        }
    }
    
    public static func == (lhs: ApiRequest, rhs: ApiRequest) -> Bool {
        if let p1 = lhs.parameters, let p2 = rhs.parameters {
            return lhs.method == rhs.method &&
                lhs.path == rhs.path &&
                NSDictionary(dictionary: p1) == NSDictionary(dictionary: p2)
        }
        
        return lhs.method == rhs.method && lhs.path == rhs.path
    }
}

struct ApiManager {
    
    private init() {}
    
    public static func request(from req: ApiRequest, completion: Completion?) {
        OriginURLSession.share.fetch(from: req) { (result) in
            switch result {
            case .success(let dictionay):
                DispatchQueue.main.async {
                    completion?(.success(dictionay))
                }
            case .failure(let err):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    completion?(.failure(err))
                })
            }
        }
    }
    
    /*public static func registerPNToken(completion: Completion?) {
        OriginURLSession.share.registerPNToken { (result) in
            switch result {
            case .success(let dictionay):
                DispatchQueue.main.async {
                    completion?(.success(dictionay))
                }
            case .failure(let err):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    completion?(.failure(err))
                })
            }
        }
    }*/
    
    /// 取消目前連線
    ///
    /// - Parameter req: see more ApiRequest
    public static func cancel(in req: ApiRequest) {
        OriginURLSession.share.cancel(in: req)
    }
    
    /// 取消目前所有連線
    public static func cancelAll() {
        OriginURLSession.share.cancelAll()
    }
}
