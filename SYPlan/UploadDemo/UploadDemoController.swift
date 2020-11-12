//
//  UploadDemoController.swift
//  SYPlan
//
//  Created by Ray on 2018/8/24.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit
import EasyAlbum

class UploadDemoController: UIViewController {
    private var mTableView: UITableView!
    
    private lazy var uploadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3.0
        configuration.timeoutIntervalForResource = 10.0
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    private let uploadService = UploadService()
    
    // 控制上傳隊列
    private let semaphore = DispatchSemaphore(value: 1)
    private let queue = DispatchQueue(label: "com.sinyi.SYPlan.Upload")
    
    private var tasks: [UploadTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = "Upload"
        
        let gallery = UIBarButtonItem(image: UIImage(named: "ic_gallery"), style: .plain, target: self, action: #selector(goGallery(_:)))
        self.navigationItem.rightBarButtonItem = gallery
        
        mTableView = UITableView(frame: .zero, style: .plain)
        mTableView.addCell(UploadTableCell.self)
        mTableView.estimatedRowHeight = 120.0
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.separatorStyle = .none
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mTableView)
        
        NSLayoutConstraint.activate([
            mTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mTableView.topAnchor.constraint(equalTo: view.topAnchor),
            mTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        uploadService.uploadSession = uploadSession
    }
    
    private func uploadPhoto(_ task: UploadTask) {
        queue.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            self.semaphore.wait()
            self.uploadService.upload(task) { (result, error) in
                if let result = result {
                    print("Upload Finish Success --> \(String(describing: result.message))")
                } else {
                    print("Upload Finish Error   --> \(String(describing: error?.localizedDescription))")
                }
                
                DispatchQueue.main.async {
                    self.uploadService.removeTask(task)
                    self.mTableView.reloadRows(at: [IndexPath(row: task.index, section: 0)], with: .none)
                }
                self.semaphore.signal()
            }
        })
    }
    
    @objc private func goGallery(_ btn: UIBarButtonItem) {
        EasyAlbum.of(appName: "SYPlan")
                 .limit(10)
                 .start(self, delegate: self)
    }
}

extension UploadDemoController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueCell(UploadTableCell.self, indexPath: indexPath)
        //print("Upload data --> \(index) - \(tasks[index].satus)")
        cell.data = tasks[index]
        cell.delegate = self
        return cell
    }
}

extension UploadDemoController: UploadTableCellDelegate {
    func reUploadTapped(_ cell: UploadTableCell) {
        uploadPhoto(cell.data)
    }
}

extension UploadDemoController: EasyAlbumDelegate {
    func easyAlbumDidSelected(_ photos: [AlbumData]) {
        if tasks.count > 0 {
            tasks.removeAll()
            mTableView.reloadData()
        }

        let queue = DispatchQueue(label: "com.sinyi.SYPlan.Resize")
        let group = DispatchGroup()
        for i in 0 ..< photos.count {
            group.enter()
            queue.async(group: group) {
                let oriImg = photos[i].image!
                self.tasks.append(UploadTask(oriImg: oriImg, clipImg: oriImg.resizeForScale(), index: i))
                print("Compression --> \(i) - \(self.tasks[i].clipImg)")
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.mTableView.reloadData()
            for task in self.tasks {
                self.uploadPhoto(task)
            }
        }
    }

    func easyAlbumDidCanceled() {

    }
}

extension UploadDemoController: URLSessionDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {

        if let uploadTask = uploadService.activeUpload[task] {
            uploadTask.progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            //print("Progress --> \(uploadTask.index) - \(uploadTask.progress)")
            DispatchQueue.main.async {
                if let cell = self.mTableView.cellForRow(at: IndexPath(row: uploadTask.index, section: 0)),
                    let uploadCell = cell as? UploadTableCell {
                    // 如果cell在可視範圍內，才更新進度
                    let cells = self.mTableView.visibleCells
                    if cells.contains(cell) {
                        uploadCell.updateDisplay(progress: uploadTask.progress)
                    }
                }
            }
        }
    }
}
