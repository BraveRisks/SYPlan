//
//  Track.swift
//  SYPlan
//
//  Created by Ray on 2018/8/17.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import Foundation

class Track {
    let name: String
    let artist: String
    let previewURL: URL
    let index: Int
    // 是否完成下載
    var downloaded = false
    
    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
    }
}
