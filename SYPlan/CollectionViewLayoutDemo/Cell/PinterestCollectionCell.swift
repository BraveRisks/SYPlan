//
//  PinterestCollectionCell.swift
//  SYPlan
//
//  Created by Ray on 2018/10/30.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class PinterestCollectionCell: UICollectionViewCell {

    @IBOutlet weak var mImgView: UIImageView!
    @IBOutlet weak var mTitleLab: UILabel!
    
    var data: Pinterest! {
        didSet { setData() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mTitleLab.backgroundColor = UIColor(hex: "000000", alpha: 0.7)
    }
    
    private func setData() {
        mImgView.image = UIImage(named: data.image)
        mTitleLab.text = data.title
        
        layer.cornerRadius = 7.5
        layer.masksToBounds = true
    }
}

struct Pinterest {
    var image: String = ""
    var title: String = ""
    
    init() {}
    
    init(image: String, title: String) {
        self.image = image
        self.title = title
    }
}
