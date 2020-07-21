//
//  OSLogDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2020/7/21.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit
import os.log

// Reference: https://www.avanderlee.com/debugging/oslog-unified-logging/
class OSLogDemoVC: BaseVC {

    private var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        Log.info(message: "View did load.", category: .other)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        textView = UITextView()
        textView?.contentInset = .init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        textView?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        textView?.textColor = UIColor(hex: "999999")
        textView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView!)
        
        // Auto Layout
        textView?.topAnchorEqual(to: view.topAnchor, constant: 10.0)
                 .isActive = true
        textView?.leadingAnchorEqual(to: view.leadingAnchor, constant: 10.0)
                 .isActive = true
        textView?.trailingAnchorEqual(to: view.trailingAnchor, constant: -10.0)
                 .isActive = true
        textView?.bottomAnchorEqual(to: view.bottomAnchor, constant: 10.0)
                 .isActive = true
        
        let content = """
        OSLog makes it possible to log per category,
        which can be used to filter logs using the Console app.
        By defining a small extension you can easily adopt multiple categories.

        -----------------------

        OS Log Level
        
        🖤 default (notice): The default log level, which is not really telling anything about the logging. It’s better to be specific by using the other log levels.

        🖤 info: Call this function to capture information that may be helpful, but isn’t essential, for troubleshooting.

        🖤 debug: Debug-level messages are intended for use in a development environment while actively debugging.

        🖤 error: Error-level messages are intended for reporting critical errors and failures.

        🖤 fault: Fault-level messages are intended for capturing system-level or multi-process errors only.

        -----------------------
        
        Logging parameters

        Parameters can be logged in two ways depending on the privacy level of the log.

        🧡 Private data can be logged using %{private}@
        🧡 Public data with %{public}@.

        example:
        
        os_log("User %{public}@ logged in", log: OSLog.userFlow, type: .info, username)
        os_log("User %{private}@ logged in", log: OSLog.userFlow, type: .info, username)

        The Xcode console will show the data as normal when a `debugger` is attached.

        LogExample[7784:105423] [viewcycle] User Antoine logged in
        LogExample[7784:105423] [viewcycle] User Antoine logged in
        
        However, opening the app while no debugger is attached will show the following output.

        LogExample  User Antoine logged in
        LogExample  User <private> logged in
        """
        textView?.text = content
    }
}
