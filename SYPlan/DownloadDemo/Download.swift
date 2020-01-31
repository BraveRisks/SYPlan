//
//  Download.swift
//  SYPlan
//
//  Created by Ray on 2018/8/17.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import Foundation

// Download service creates Download objects
class Download {
    var track: Track
    
    // Download service sets these values:
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?
    
    // Download delegate sets this value:
    var progress: Float = 0
    
    init(track: Track) {
        self.track = track
    }
}
