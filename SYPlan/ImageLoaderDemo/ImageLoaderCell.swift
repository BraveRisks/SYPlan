//
//  ImageLoaderCell.swift
//  SYPlan
//
//  Created by Ray on 2020/2/26.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class ImageLoaderCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var pathLabel: UILabel!
    
    var item: (image: UIImage?, path: String?)? {
        didSet { setData() }
    }
    
    var onReuse: (() -> Swift.Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        onReuse?()
        pictureImageView.image = nil
        pathLabel.text = nil
        super.prepareForReuse()
    }
    
    private func setup() {
        pictureImageView.contentMode = .scaleAspectFill
    }
    
    private func setData() {
        guard let item = item else { return }
        
        pictureImageView.image = item.image
        pathLabel.text = item.path
    }
}
