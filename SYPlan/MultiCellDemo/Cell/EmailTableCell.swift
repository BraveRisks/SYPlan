//
//  EmailTableCell.swift
//  SYPlan
//
//  Created by Ray on 2018/8/22.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class EmailTableCell: UITableViewCell {

    @IBOutlet weak var mEmailLab: UILabel!
    
    var data: String? {
        didSet { setData(data) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setData(_ data: String?) {
        mEmailLab.text = data
    }
}
