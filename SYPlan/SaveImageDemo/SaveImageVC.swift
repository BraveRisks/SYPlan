//
//  SaveImageVC.swift
//  SYPlan
//
//  Created by Ray on 2020/2/24.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

enum StorageType {
    
    /// Save to UserDefaults
    case userdefaults(key: String)
    
    /// Save to system folder
    case file(fileName: String?)
    
}

class SaveImageModel {
    
    var image: UIImage?
    
    /// UserDefaults Key
    var key: String
    
    /// 檔案名稱
    var fileName: String
    
    /// 是否儲存在`UserDefaults`，defualt = false
    var inUserDefaults: Bool = false
    
    /// 是否儲存在`Folder`，default = false
    var inFolder: Bool = false

    init(image: UIImage?, key: String, fileName: String) {
        self.image = image
        self.key = key
        self.fileName = fileName
    }
}

class SaveImageVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    private let defaults: UserDefaults = UserDefaults.standard
    private let file: FileManager = FileManager.default
    
    private var datas: [SaveImageModel] = []
    
    private var documentURL: URL? {
        return file.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        fakeData()
        
        imageView.contentMode = .scaleAspectFill
        
        tableView.addCell(SaveImageCell.self, isNib: true)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fakeData() {
        for i in 12 ..< 18 {
            let str = "photo_\(i)"
            let model = SaveImageModel(image: UIImage(named: str), key: str, fileName: "\(str).png")
            
            if let _ = defaults.value(forKey: str) as? Data {
                model.inUserDefaults = true
            }
            
            if let url = documentURL {
                let filePath = url.appendingPathComponent("\(str).png")
                model.inFolder = file.fileExists(atPath: filePath.path, isDirectory: nil)
            }
 
            datas.append(model)
        }
    }

    private func saveImage(in type: StorageType, image: UIImage?) {
        guard let img = image, let data = img.pngData() else { return }
        
        switch type {
        case .userdefaults(let key):
            defaults.set(data, forKey: key)
        case .file(let fileName):
            guard let url = documentURL else { return }
            
            let df = DateFormatter()
            df.dateFormat = "yyyyMMdd_HHmmss"
            
            var tempName = df.string(from: Date())
            if let fileName = fileName { tempName = fileName }
            
            let filePath = url.appendingPathComponent("\(tempName)")
            do {
                try data.write(to: filePath, options: .atomic)
                print("filePath = \(filePath)")
            } catch let error {
                print("Save image to file error = \(error)")
            }
        }
    }
    
    private func deleteImage(in type: StorageType, index: Int) {
        let model = datas[index]
        
        switch type {
        case .userdefaults(let key):
            defaults.removeObject(forKey: key)
            model.inUserDefaults = false
        case .file(let fileName):
            guard let url = documentURL, let fileName = fileName else { return }
            
            let filePath = url.appendingPathComponent(fileName)
            do {
                try file.removeItem(at: filePath)
                model.inFolder = false
            } catch let error {
                print("Delete image error = \(error)")
            }
        }
        
        imageView.image = nil
        tableView.reloadData()
    }
    
    private func showImageFrom(type: StorageType) {
        switch type {
        case .userdefaults(let key):
            DispatchQueue.global(qos: .background).async {
                if let data = self.defaults.value(forKey: key) as? Data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        case .file(let fileName):
            guard let url = documentURL, let fileName = fileName else { return }
            
            let filePath = url.appendingPathComponent(fileName)
            if let data = file.contents(atPath: filePath.path) {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    private func showAlert(on index: Int) {
        let model = datas[index]
        let image = model.image
        let key = model.key
        let fileName = model.fileName
        
        let ac = UIAlertController(title: "選擇動作", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "儲存圖片至UserDefaults", style: .default) { (action) in
            self.saveImage(in: .userdefaults(key: key), image: image)
            self.datas[index].inUserDefaults = true
            self.tableView.reloadData()
        }
        
        let action2 = UIAlertAction(title: "儲存圖片至Folder", style: .default) { (action) in
            self.saveImage(in: .file(fileName: fileName), image: image)
            self.datas[index].inFolder = true
            self.tableView.reloadData()
        }
        
        let action3 = UIAlertAction(title: "從UserDefaults顯示圖片", style: .default) { (action) in
            self.showImageFrom(type: .userdefaults(key: key))
        }
        
        let action4 = UIAlertAction(title: "從Folder顯示圖片", style: .default) { (action) in
            self.showImageFrom(type: .file(fileName: fileName))
        }
        
        let action5 = UIAlertAction(title: "將圖片從UserDefaults移除", style: .destructive) { (action) in
            self.deleteImage(in: .userdefaults(key: key), index: index)
        }
        
        let action6 = UIAlertAction(title: "將圖片從Folder移除", style: .destructive) { (action) in
            self.deleteImage(in: .file(fileName: fileName), index: index)
        }
        
        let cancel = UIAlertAction(title: "關閉", style: .cancel, handler: nil)
        
        ac.addAction(action1)
        ac.addAction(action2)
        ac.addAction(action3)
        ac.addAction(action4)
        ac.addAction(action5)
        ac.addAction(action6)
        ac.addAction(cancel)
        
        present(ac, animated: true, completion: nil)
    }
}

extension SaveImageVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueCell(SaveImageCell.self, indexPath: indexPath)
        
        cell.item = datas[index]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        showAlert(on: indexPath.row)
    }
}
