//
//  UploadResult.swift
//  SYPlan
//
//  Created by Ray on 2018/8/30.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import Foundation

class UploadResult: Codable {
    var status: Bool
    var message: String
    var sendTime: String
    
    init(status: Bool, message: String, sendTime: String) {
        self.status = status
        self.message = message
        self.sendTime = sendTime
    }
}
