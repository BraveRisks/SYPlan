//
//  ProfileTableCell.swift
//  SYPlan
//
//  Created by Ray on 2018/8/22.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit
//import Kingfisher

class ProfileTableCell: UITableViewCell {

    @IBOutlet weak var mPhotoImgView: UIImageView!
    @IBOutlet weak var mNameLab: UILabel!
    
    var datas: (name: String, photo: String)! {
        didSet { setData(name: datas.name, photo: datas.photo) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mPhotoImgView.contentMode = .scaleAspectFill
        mPhotoImgView.layer.cornerRadius = 40.0
        mPhotoImgView.layer.masksToBounds = true
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setData(name: String, photo: String) {
        mNameLab.text = name
        //mPhotoImgView.kf.setImage(with: URL(string: photo)!)
    }
}
