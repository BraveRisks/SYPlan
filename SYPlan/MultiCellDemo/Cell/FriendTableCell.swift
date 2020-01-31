//
//  FriendTableCell.swift
//  SYPlan
//
//  Created by Ray on 2018/8/22.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit
//import Kingfisher

class FriendTableCell: UITableViewCell {

    @IBOutlet weak var mPhotoImgView: UIImageView!
    @IBOutlet weak var mNameLab: UILabel!
    
    var data: Profile.Friend! {
        didSet { setData(data)}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mPhotoImgView.contentMode = .scaleAspectFill
        mPhotoImgView.layer.cornerRadius = mPhotoImgView.frame.width / 2
        mPhotoImgView.layer.masksToBounds = true
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setData(_ firend: Profile.Friend) {
        mNameLab.text = firend.name
        //mPhotoImgView.kf.setImage(with: URL(string: firend.photo))
        //mPhotoImgView.image = UIImage(named: gender ? "ic_male" : "ic_female")
    }
}
