//
//  Article.swift
//  SYPlan
//
//  Created by Ray on 2018/10/16.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class Article: NSObject, Codable, ArticleViewModelDelegate {
    var type: ArticleType {
        return .default
    }
    
    var rowHeight: CGFloat {
        return 240.0
    }
    
    private(set) var title: String = ""
    private(set) var imgURL: String = ""
    private(set) var issuer: String = ""
    private(set) var issuerImgURL: String = ""
    var favorites: Int = 0
    
    override init() {
        super.init()
    }
    
    convenience init(title: String, imgURL: String, issuer: String, issuerImgURL: String, favorites: Int) {
        self.init()
        self.title = title
        self.imgURL = imgURL
        self.issuer = issuer
        self.issuerImgURL = issuerImgURL
        self.favorites = favorites
    }
}
