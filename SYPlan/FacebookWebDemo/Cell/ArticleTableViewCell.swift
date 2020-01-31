//
//  ArticleTableViewCell.swift
//  SYPlan
//
//  Created by Ray on 2018/10/16.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var mImgView: UIImageView!
    @IBOutlet weak var mTitleLab: UILabel!
    @IBOutlet weak var mIssuerLab: UILabel!
    @IBOutlet weak var mIssuerImg: UIImageView!
    @IBOutlet weak var mFavoritesLab: UILabel!
    
    var article: Article! {
        didSet { setData() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        mImgView.layer.cornerRadius = 7.0
        mIssuerImg.layer.cornerRadius = mIssuerImg.frame.height / CGFloat(2.0)
    }
    
    private func setData() {
        mImgView.image = UIImage(named: article.imgURL)
        mTitleLab.text = article.title
        //mIssuerLab.text = article.issuer
        //mIssuerImg.image = UIImage(named: article.issuerImgURL)
        mFavoritesLab.text = "\(article.favorites)"
    }
    
}
