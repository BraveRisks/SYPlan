//
//  ArticleViewModel.swift
//  SYPlan
//
//  Created by Ray on 2018/10/16.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

enum ArticleType {
    case `default`
    case image
}

protocol ArticleViewModelDelegate {
    var type: ArticleType { get }
    var rowHeight: CGFloat { get }
}

class ArticleViewModel: NSObject {
    
    var articles: [ArticleViewModelDelegate] = []
    var data: Data! {
        didSet { parse(from: data) }
    }
    
    override init() {
        super.init()
    }
    
    private func parse(from data: Data) {
        let decoder = JSONDecoder()
        do {
            let datas = try decoder.decode([Article].self, from: data)
            for d in datas {
                articles.append(Article(title: d.title, imgURL: d.imgURL, issuer: d.issuer, issuerImgURL: d.issuerImgURL, favorites: d.favorites))
            }
        } catch let error {
            print("Error --> \(error)")
        }
    }
}
