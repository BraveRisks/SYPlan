//
//  ApiPath.swift
//  SYPlan
//
//  Created by Ray on 2019/12/19.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import Foundation

enum ApiPath: String {
    
    /// 取得Token，path = taGetAuthToken
    case taGetAuthToken = "taGetAuthToken"
    
    /// 客戶搜尋，path = SearchCustomerList
    ///
    /// ```
    /// {
    ///   "UserID": "225315",
    ///   "SearchKeyWord": "",
    ///   "UserLat": "25.034263",
    ///   "UserLng": "121.564478",
    ///   "CustType": "3",
    ///   "DevType": "2",
    ///   "ApName": "TA2"
    /// }
    /// ```
    case searchCustomerList = "SearchCustomerList"
    
    /// 常用會面地點，path = GetMeetPlace
    ///
    /// ```
    /// {
    ///   "UserID": "225315",
    ///   "UserLat": "25.034263",
    ///   "UserLng": "121.564478",
    ///   "DevType": "2",
    ///   "ApName": "TA2"
    /// }
    /// ```
    case getMeetPlace = "GetMeetPlace"
}
