//
//  UploadTask.swift
//  SYPlan
//
//  Created by Ray on 2018/8/29.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

enum TaskStatus {
    case send
    case fail
    case success
}

class UploadTask {
    var oriImg: UIImage
    var clipImg: UIImage
    var progress: Float = 0
    var satus: TaskStatus = .send
    var sendTime: String = ""
    var index: Int
    
    init(oriImg: UIImage, clipImg: UIImage, index: Int) {
        self.oriImg = oriImg
        self.clipImg = clipImg
        self.index = index
    }
}
