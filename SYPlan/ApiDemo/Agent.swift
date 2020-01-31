//
//  Agent.swift
//  SYPlan
//
//  Created by Ray on 2019/12/19.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import Foundation

/// 登入者 Model
struct Agent: Decodable {
    
    /// 公司別代號
    var companyID: String
    
    /// 人員編號
    var userID: String
    
    /// 人員姓名
    var userName: String
    
    /// 手機號碼
    var userPhone: String
    
    /// 職稱代碼
    var jobID: String
    
    /// 職稱中文
    var jobName: String
    
    /// 職稱角色 1: 店長, 2: 秘書, 3: 業務, 4: 副總, 5: 區主管
    var jobTitle: String
    
    /// 部門代碼
    var deptID: String
    
    /// 部門名稱
    var deptName: String
    
    /// 單位設定碼
    /// ```
    /// A： 分店  B：業務區  C： 代書  D：鑑價    E：代銷  F：專案  G：全球  H：安信
    /// I： 室內  J：出版    K： 設計  L：事業處  M：建設  N：大馬  O：     P：人事
    /// ```
    var deptType: String
    
    /// 部門郵遞區號
    var deptZip: String
    
    /// 部門緯度
    var deptLat: String
    
    /// 部門經度
    var deptLng: String
    
    /// 上層部門代號
    var upperDeptID: String
    
    /// 上層部門名稱
    var upperDeptName: String
    
    /// 登入時是否彈跳警語視窗 Y: 是, N: 否
    var popup: Bool
    
    /// Token
    var gKey: String
    
    /// 測試模式
    var debugModel: Bool
    
    /// 是否為店長，default = false
    var isStoreManager: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case companyID = "CompanyID"
        case userID = "UserID"
        case userName = "UserName"
        case userPhone = "UserPhone"
        case jobID = "JobID"
        case jobName = "JobName"
        case jobTitle = "JobTitle"
        case deptID = "DeptID"
        case deptName = "DeptName"
        case deptType = "DeptType"
        case deptZip = "DeptZip"
        case deptLat = "DeptLat"
        case deptLng = "DeptLng"
        case upperDeptID = "UpperDeptID"
        case upperDeptName = "UpperDeptName"
        case popup = "Popup"
        case gKey = "GKey"
        case debugModel = "DebugModel"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        companyID = try container.decode(String.self, forKey: .companyID)
        userID = try container.decode(String.self, forKey: .userID)
        userName = try container.decode(String.self, forKey: .userName)
        userPhone = try container.decodeIfPresent(String.self, forKey: .userPhone) ?? ""
        jobID = try container.decodeIfPresent(String.self, forKey: .jobID) ?? ""
        jobName = try container.decodeIfPresent(String.self, forKey: .jobName) ?? ""
        jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitle) ?? ""
        deptID = try container.decode(String.self, forKey: .deptID)
        deptName = try container.decode(String.self, forKey: .deptName)
        deptType = try container.decode(String.self, forKey: .deptType)
        deptZip = try container.decode(String.self, forKey: .deptZip)
        deptLat = try container.decode(String.self, forKey: .deptLat)
        deptLng = try container.decode(String.self, forKey: .deptLng)
        upperDeptID = try container.decode(String.self, forKey: .upperDeptID)
        upperDeptName = try container.decode(String.self, forKey: .upperDeptName)
        popup = try container.decode(String.self, forKey: .popup) == "Y"
        gKey = try container.decode(String.self, forKey: .gKey)
        debugModel = try container.decodeIfPresent(String.self, forKey: .debugModel) == "Y"
        
        // 取單位代碼前2碼 或是 取職位代碼前1碼
        isStoreManager = deptID.hasPrefix("M2") || jobTitle.hasPrefix("M")
    }
}
