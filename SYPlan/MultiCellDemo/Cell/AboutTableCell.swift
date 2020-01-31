//
//  AboutTableCell.swift
//  SYPlan
//
//  Created by Ray on 2018/8/22.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class AboutTableCell: UITableViewCell {
    @IBOutlet weak var mAboutLab: UILabel!
    
    var data: String! {
        didSet { setData(data) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setData(_ data: String) {
        mAboutLab.text = data
    }
}
