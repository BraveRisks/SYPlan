import UIKit

//class BaseSendModel: Encodable {
//
//    /// 使用者ID
//    var memberId: String?
//
//    /// 裝置代碼
//    var machineNo: String?
//
//    /// IP
//    var ipAddress: String?
//
//    /// 作業系統
//    var osType: String?
//
//    /// 產品型號
//    var model: String?
//
//    /// 廠牌商標
//    var tradeMark: String?
//
//    /// OS版本
//    var deviceVersion: String?
//
//    /// App版本編號
//    var appVersion: String?
//
//    /// 裝置
//    var deviceType: String?
//
//    /// 應用程式種類
//    var apType: String?
//
//    /// 瀏覽器
//    var browser: String?
//
//    /// 轉成 Dictionary<String, Any>
////    var parameters: JSONDictionary? {
////        let encoder = JSONEncoder()
////        if let data = try? encoder.encode(self), let dictionary = data.dictionary {
////            return dictionary
////        }
////
////        return nil
////    }
//
//    private enum CodingKeys: String, CodingKey {
//        case memberId = "memberId"
//        case machineNo = "machineNo"
//        case ipAddress = "ipAddress"
//        case osType = "osType"
//        case model = "model"
//        case tradeMark = "tradeMark"
//        case deviceVersion = "deviceVersion"
//        case appVersion = "AppVersion"
//        case deviceType = "deviceType"
//        case apType = "apType"
//        case browser = "browser"
//    }
//
//    init() {
//        memberId = "1"
//        machineNo = "2"
//        ipAddress = "3"
//        osType = "4"
//        model = "5"
//        tradeMark = "6"
//        deviceVersion = "7"
//        appVersion = "8"
//        deviceType = "9"
//        apType = "10"
//        browser = "11"
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(memberId, forKey: .memberId)
//        try container.encodeIfPresent(machineNo, forKey: .machineNo)
//        try container.encodeIfPresent(ipAddress, forKey: .ipAddress)
//        try container.encodeIfPresent(osType, forKey: .osType)
//        try container.encodeIfPresent(model, forKey: .model)
//        try container.encodeIfPresent(tradeMark, forKey: .tradeMark)
//        try container.encodeIfPresent(deviceVersion, forKey: .deviceVersion)
//        try container.encodeIfPresent(appVersion, forKey: .appVersion)
//        try container.encodeIfPresent(deviceType, forKey: .deviceType)
//        try container.encodeIfPresent(apType, forKey: .apType)
//        try container.encodeIfPresent(browser, forKey: .browser)
//    }
//}
//
//class ObjectContentModel: BaseSendModel {
//
//    var houseNo: String?
//
//    var agentId: String?
//
//    init(houseNo: String?, agentId: String?) {
//        super.init()
//
//        self.houseNo = houseNo
//        self.agentId = agentId
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case houseNo = "houseNo"
//        case agentId = "agentId"
//    }
//
//    override func encode(to encoder: Encoder) throws {
//        try super.encode(to: encoder)
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(houseNo, forKey: .houseNo)
//        try container.encodeIfPresent(agentId, forKey: .agentId)
//    }
//}
//
//let m = ObjectContentModel(houseNo: "123", agentId: nil)
//let encoder = JSONEncoder()
//encoder.outputFormatting = .prettyPrinted
//
//do {
//    let data = try encoder.encode(m)
//    let result = String(data: data, encoding: .utf8)
//    print("Result = \(String(describing: result))")
//} catch let error {
//    print("Error = \(error)")
//}
