//
//  SaveImageCell.swift
//  SYPlan
//
//  Created by Ray on 2020/2/24.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class SaveImageCell: UITableViewCell {

    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var userDefaultsImageView: UIImageView!
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var otherImageView: UIImageView!

    var item: SaveImageModel? {
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
        showImageView.contentMode = .scaleAspectFit
    }
    
    private func setData() {
        guard let item = item else { return }
        
        showImageView.image = item.image
        userDefaultsImageView.image = item.inUserDefaults ? UIImage(named: "ic_sdcard") :
                                                            UIImage(named: "ic_unsdcard")
        fileImageView.image = item.inFolder ? UIImage(named: "ic_folder") :
                                              UIImage(named: "ic_unfolder")
    }
}
