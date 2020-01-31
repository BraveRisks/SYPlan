//
//  ChatTableCell.swift
//  SYPlan
//
//  Created by Ray on 2018/8/29.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

protocol UploadTableCellDelegate: class  {
    func reUploadTapped(_ cell: UploadTableCell)
}

class UploadTableCell: UITableViewCell {

    @IBOutlet weak var mPhotoImgView: UIImageView!
    @IBOutlet weak var mSendImgView: UIImageView!
    @IBOutlet weak var mMaskView: UIView!
    @IBOutlet weak var mTimeLab: UILabel!
    @IBOutlet weak var mProgressLab: UILabel!
    @IBOutlet weak var mReUploadBtn: UIButton!
    @IBOutlet weak var mSendImgWidthCons: NSLayoutConstraint!
    
    private let radius: CGFloat = 7.0
    
    var data: UploadTask! {
        didSet { setData() }
    }
    
    weak var delegate: UploadTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //mPhotoImgView.addCorner(radius: mPhotoImgView.frame.height / 2)
        mPhotoImgView.layer.cornerRadius = mPhotoImgView.frame.height / 2
        mPhotoImgView.layer.masksToBounds = true
        mSendImgView.layer.cornerRadius = radius
        mSendImgView.layer.masksToBounds = true
        mMaskView.layer.cornerRadius = radius
        mMaskView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        mProgressLab.layer.cornerRadius = mProgressLab.frame.height / 2
        mProgressLab.layer.borderColor = UIColor.white.cgColor
        mProgressLab.layer.borderWidth = 1.5
        mReUploadBtn.layer.cornerRadius = mReUploadBtn.frame.height / 2
        mReUploadBtn.layer.masksToBounds = true
        mReUploadBtn.isHidden = true
        mReUploadBtn.addTarget(self, action: #selector(reUpload(_:)), for: .touchUpInside)
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setData() {
        mSendImgWidthCons.constant = data.clipImg.size.width
        mSendImgView.image = data.clipImg
        
        mTimeLab.text = data.sendTime
        mMaskView.isHidden = data.satus != .send
        
        mProgressLab.isHidden = !(data.satus == .send)
        mProgressLab.text = "\(data.progress)%"
        
        mReUploadBtn.isHidden = data.satus != .fail
    }
    
    func updateDisplay(progress: Float) {
        mProgressLab.text = String(format: "%.0f%%", progress * 100)
    }
    
    @objc private func reUpload(_ btn: UIButton) {
        mReUploadBtn.isHidden = true
        mMaskView.isHidden = false
        mProgressLab.isHidden = false
        delegate?.reUploadTapped(self)
    }
}
