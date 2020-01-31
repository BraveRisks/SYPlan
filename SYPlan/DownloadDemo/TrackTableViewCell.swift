//
//  TrackTableViewCell.swift
//  SYPlan
//
//  Created by Ray on 2018/8/17.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

protocol TrackTableViewCellDelegate: class {
    func pauseTapped(_ cell: TrackTableViewCell)
    func resumeTapped(_ cell: TrackTableViewCell)
    func cancelTapped(_ cell: TrackTableViewCell)
    func downloadTapped(_ cell: TrackTableViewCell)
}

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var mArtImgView: UIImageView!
    @IBOutlet weak var mTitleLab: UILabel!
    @IBOutlet weak var mArtListLab: UILabel!
    
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mPauseBtn: UIButton!
    @IBOutlet weak var mDownloadBtn: UIButton!
    
    @IBOutlet weak var mProgressView: UIProgressView!
    @IBOutlet weak var mProgressLab: UILabel!
    
    weak var delegate: TrackTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mDownloadBtn.addTarget(self, action: #selector(downloadTapped(_:)), for: .touchUpInside)
        mPauseBtn.addTarget(self, action: #selector(pauseOrResumeTapped(_:)), for: .touchUpInside)
        mCancelBtn.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(track: Track, downloaded: Bool, download: Download?) {
        mTitleLab.text = track.name
        mArtListLab.text = track.artist
        
        // Download controls are Pause/Resume, Cancel buttons, progress info
        var showDownloadControls = false
        // Non-nil Download object means a download is in progress
        if let download = download {
            showDownloadControls = true
            let title = download.isDownloading ? "Pause" : "Resume"
            mPauseBtn.setTitle(title, for: .normal)
            mProgressView.progress = download.progress
            mProgressLab.text = download.isDownloading ? "Downloading..." : "Paused"
        }
        
        mPauseBtn.isHidden = !showDownloadControls
        mCancelBtn.isHidden = !showDownloadControls
        mProgressView.isHidden = !showDownloadControls
        mProgressLab.isHidden = !showDownloadControls
        
        // If the track is already downloaded, enable cell selection and hide the Download button
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none
        mDownloadBtn.isHidden = downloaded || showDownloadControls
    }
    
    func updateDisplay(progress: Float, totalSize : String) {
        mProgressView.progress = progress
        mProgressLab.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
    
    @objc private func pauseOrResumeTapped(_ btn: UIButton) {
        if mPauseBtn.titleLabel!.text == "Pause" {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    @objc private func cancelTapped(_ btn: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    @objc private func downloadTapped(_ btn: UIButton) {
        delegate?.downloadTapped(self)
    }
}
