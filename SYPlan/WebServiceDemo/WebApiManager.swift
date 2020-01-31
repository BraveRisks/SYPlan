//
//  ApiManager.swift
//  SYPlan
//
//  Created by Ray on 2019/4/29.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import Foundation

#if DEBUG
let basePath: String = "https://apitest.sinyi.com.tw/JServer/JT000A.asmx"
#else
let basePath: String = "https://api.sinyi.com.tw/JServer/JT000A.asmx"
#endif

/// Dictionary<String, Any>的別名
typealias JSON = Dictionary<String, Any>

/// Api callback `completion`
typealias WebCompletion = (Result<JSON, WebApiError>) -> Swift.Void

/// 記錄目前的Token，default：""
var webGKey: String = ""

/// 記錄目前請求的web service name，default：.ssIphoneRegister
var currentSoapName: SoapName = .ssIphoneRegister

/// 記錄目前API回應後的內容，default：""
var currentXMLResult: String = ""

enum WebApiError: Error {
    case networkError
    
    case invalidURL(url: String)
    
    case nilData
    
    case parseXMLFailed
    
    case resultFailed(code: Int)
    
    case appUpdate(url: String)
    
    case other(msg: String)
    
    var message: String {
        get {
            switch self {
            case .networkError: return "🥺 請確認目前網路狀態是否連接！"
            case .invalidURL(let url): return "🥺 \(url) 👉🏻 是無效的URL！"
            case .nilData: return "🥺 Response data nil！"
            case .parseXMLFailed: return "🥺 解析XML失敗！"
            case .resultFailed(let code):
                switch code {
                case 202, 203, 204:
                    let msg = """
                    🥺 您的帳號已在另一台機器中使用，請店長或秘書先將您的帳號刪除後即可在此台機器登入。或洽資訊部分機2200
                    """
                    return msg
                case 301: return "🥺 啟用軟體過程發生錯誤"
                case 302, 303: return "🥺 系統發生異常"
                case 300, 400: return "🥺 請輸入正確的帳號密碼"
                case 401: return "🥺 內部無此員工資料"
                case 402: return "🥺 該人員or該分店未允許使用服務"
                case 403: return "🥺 人員登記之裝置編號認證錯誤"
                case 404: return "🥺 JSON格式錯誤"
                case 405: return "🥺 輸入資料有漏"
                case 406: return "🥺 伺服器維護中，請稍候再試"
                default: return "🥺 伺服器維護中，請稍候再試"
                }
            case .appUpdate(let url): return "🥺 需要更新軟體版本才能繼續使用;\(url)"
            case .other(let msg): return "🥺 \(msg)"
            }
        }
    }
}

enum SoapName: String {
    /// name：SSIphoneRegister
    case ssIphoneRegister = "SSIphoneRegister"
    
    /// name：SinyiEmployeeInfo
    case sinyiEmployeeInfo = "SinyiEmployeeInfo"
    
    /// name：SinyiAppStoreList
    case sinyiAppStoreList = "SinyiAppStoreList"
    
    func data(param: SoapParameters) -> Data? {
        let soapName: String = self.rawValue
        var body: String = ""
        
        switch param {
        case .login(let user, let pass):
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
            let devID = "554543bc7d8e409db3d6a600343ec06a"
            body = """
            <strID>\(user)</strID>
            <strPW>\(pass)</strPW>
            <strDevNewHID>\(devID)</strDevNewHID>
            <strVer>\(version)</strVer>
            """
        case .other(let param, let extParam):
            body = """
            <strGKey>\(webGKey)</strGKey>
            <strParam>\(param.string)</strParam>
            <strExtParam>\(extParam?.string ?? "")</strExtParam>
            """
        }
        
        let msg = """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
        <\(soapName) xmlns="http://www.januarytc.com/">
        \(body)
        </\(soapName)>
        </soap:Body>
        </soap:Envelope>
        """
        return msg.data(using: .utf8)
    }
}

enum SoapParameters {
    case login(user: String, pass: String)
    
    case other(param: JSON, extParam: JSON?)
}

enum WebHttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public struct WebHttpHeader {
    var field: String
    var value: String
    
    /// xml，Content-Type:text/xml; charset=utf-8
    static var xml: HttpHeader {
        get { return HttpHeader(field: "Content-Type", value: "text/xml; charset=utf-8") }
    }
    
    /// json，Content-Type:text/xml
    static var json: HttpHeader {
        get { return HttpHeader(field: "Content-Type", value: "application/json") }
    }
}

public struct WebApiRequest: Hashable {
    
    var method: WebHttpMethod
    var soapName: SoapName
    var headers: [HttpHeader]?
    
    init(method: WebHttpMethod, soapName: SoapName) {
        self.method = method
        self.soapName = soapName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(method)
        hasher.combine(soapName)
    }
    
    public static func == (lhs: WebApiRequest, rhs: WebApiRequest) -> Bool {
        return lhs.method == rhs.method && lhs.soapName == rhs.soapName
    }
}

struct WebApiManager {
    
    private init() {}
    
    public static func fetch(from req: WebApiRequest, with param: SoapParameters,
                             completion: @escaping WebCompletion) {
        HttpSession.share.fetch(from: req, with: param, completion: completion)
    }
}
