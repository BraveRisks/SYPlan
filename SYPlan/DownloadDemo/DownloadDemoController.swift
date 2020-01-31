//
//  DownloadDemoController.swift
//  SYPlan
//
//  Created by Ray on 2018/8/17.
//  Copyright © 2018年 Sinyi. All rights reserved.
//  https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/
//  https://qiita.com/rinov/items/f30d386fb7b8b12278a5

import UIKit

class DownloadDemoController: UIViewController {
    
    private var mTableView: UITableView!
    private let cellIdentifier = "TrackTableViewCell"
    
    let queryService = QueryService()
    let downloadService = DownloadService()
    
    /*
     .default: Creates a default configuration object that uses the disk-persisted global cache, credential and cookie storage objects.
     .ephemeral: Similar to the default configuration, except that all session-related data is stored in memory. Think of this as a “private” session.
     .background: Lets the session perform upload or download tasks in the background. Transfers continue even when the app itself is suspended or terminated by the system.
     */
    // Create downloadsSession here, to set self as delegate
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "DownloadSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    // Get local file path: download task stores tune here; AV player plays it.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    var trackList: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchTracks()
    }

    private func setupView() {
        mTableView = UITableView(frame: CGRect.zero, style: .plain)
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        view.addSubview(mTableView)
        mTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: mTableView!, attribute: .top,
                           relatedBy: .equal,
                           toItem: view, attribute: .top,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .leading,
                           relatedBy: .equal,
                           toItem: view, attribute: .leading,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .trailing,
                           relatedBy: .equal,
                           toItem: view, attribute: .trailing,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view, attribute: .bottom,
                           multiplier: 1.0, constant: 0.0).isActive = true
        
        downloadService.downloadsSession = downloadsSession
    }
    
    private func fetchTracks() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryService.fetchTrackList(query: "push") { (tracks, errMsg) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let tracks = tracks {
                self.trackList = tracks
                self.mTableView.reloadData()
                self.mTableView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }
}
extension DownloadDemoController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrackTableViewCell
        
        let track = trackList[index]
        cell.configure(track: track, downloaded: track.downloaded, download: downloadService.activeDownloads[track.previewURL])
        cell.delegate = self
        return cell
    }
}
extension DownloadDemoController: TrackTableViewCellDelegate {
    func pauseTapped(_ cell: TrackTableViewCell) {
        if let indexPath = mTableView.indexPath(for: cell) {
            let track = trackList[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: TrackTableViewCell) {
        if let indexPath = mTableView.indexPath(for: cell) {
            let track = trackList[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
    
    func cancelTapped(_ cell: TrackTableViewCell) {
        if let indexPath = mTableView.indexPath(for: cell) {
            let track = trackList[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }
    
    func downloadTapped(_ cell: TrackTableViewCell) {
        if let indexPath = mTableView.indexPath(for: cell) {
            let track = trackList[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }
    
    func reload(_ row: Int) {
        mTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}
extension DownloadDemoController: URLSessionDownloadDelegate {
    // Stores downloaded file
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil

        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)

        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }

        if let index = download?.track.index {
            DispatchQueue.main.async {
                self.mTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    // Updates progress info
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        guard let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url] else { return }
        
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)

        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)

        DispatchQueue.main.async {
            if let trackCell = self.mTableView.cellForRow(at: IndexPath(row: download.track.index, section: 0)) as? TrackTableViewCell {
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
            }
        }
    }
}
extension DownloadDemoController: URLSessionDelegate {
    // Standard background session handler
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}
