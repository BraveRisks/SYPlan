//
//  SYCore.swift
//  SYPlan
//
//  Created by Ray on 2019/3/14.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit
import Crashlytics

enum ShortcutItem {
    
    case qrCode
    
    case web
    
    case download
    
    var item: UIApplicationShortcutItem {
        switch self {
        case .qrCode:
            // UIApplicationShortcutIcon(templateImageName: "symbol_qrcode")
            // UIApplicationShortcutIcon(systemImageName: "faceid")
            return UIApplicationShortcutItem(type: "QRCode",
                                             localizedTitle: "掃描QRCode",
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "symbol_qrcode"),
                                             userInfo: nil)
        case .web:
            // UIApplicationShortcutIcon(templateImageName: "symbol_web")
            // UIApplicationShortcutIcon(systemImageName: "safari.fill")
            return UIApplicationShortcutItem(type: "Web",
                                             localizedTitle: "開啟網頁",
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "symbol_web"),
                                             userInfo: nil)
        case .download:
            // UIApplicationShortcutIcon(templateImageName: "symbol_download")
            // UIApplicationShortcutIcon(systemImageName: "icloud.and.arrow.down.fill")
            return UIApplicationShortcutItem(type: "Download",
                                             localizedTitle: "下載音樂",
                                             localizedSubtitle: nil,
                                             icon: UIApplicationShortcutIcon(templateImageName: "symbol_download"),
                                             userInfo: nil)
        }
    }
}

/// 紀錄Crash發生處
func crashLog(with msg: String = "", file: String = #file, line: Int = #line) {
    let name = (file as NSString).lastPathComponent
    let log = """
    1️⃣ class 👉🏻 \(name) - 第\(line)行
    2️⃣ message 👉🏻 \(msg)
    """
    CLSLogv("%@", getVaList([log]))
}
