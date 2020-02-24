//
//  WatermarkView.swift
//  SYPlan
//
//  Created by Ray on 2019/9/10.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class WatermarkView: UIView {

    private var collectionView: UICollectionView?
    private var logoImageView: UIImageView?
    
    /// 透明度，value = 0.4
    private let transparentValue: CGFloat = 0.4
    
    private var itemSize: CGSize = .zero
    private var itemCount: Int = 0
    
    /// 浮水印上的文字，UserID ＋ SINYI
    private var values: [String] = ["Testers", "SINYI"]
    
    private var userID: String?
    
    convenience init(frame: CGRect, userID id: String?) {
        self.init(frame: frame)
        if let id = id { values[0] = id }
        setup()
    }
    
    private func setup() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = CGFloat(0)
        flowLayout.minimumLineSpacing = CGFloat(0)
        
        // 計算Item的大小
        itemSize = CGSize(width: frame.width / 5, height: 32.0)
        flowLayout.itemSize = itemSize
        
        // 計算Item數量 = (高度 / item高度) * 5
        // 乘於5，因為每行有5個
        itemCount = Int(frame.height / itemSize.height) * 5
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView?.addCell(WatermarkView.Cell.self, isNib: false)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = .clear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        addSubview(collectionView!)
        
        logoImageView = UIImageView(image: UIImage(named: "ic_watermark"))
        logoImageView?.center = center
        logoImageView?.contentMode = .scaleAspectFit
        logoImageView?.alpha = transparentValue
        addSubview(logoImageView!)

        backgroundColor = .clear
        alpha = transparentValue        
    }
    
    func asImage(completionHandler: @escaping (UIImage?) -> Swift.Void) {
        let size = bounds.size
        print("!! start \(Date().milliStamp)")
        
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = 1.0
                format.opaque = false
                
                let renderer = UIGraphicsImageRenderer(size: size, format: format)
                let image = renderer.image { context in
                    // Use layer is slow
                    //self.layer.render(in: context.cgContext)
                    
                    // Use drawHierarchy is fast
                    var rect = self.frame
                    rect.origin = CGPoint(x: 0.0, y: -44.0)
                    self.drawHierarchy(in: rect, afterScreenUpdates: true)
                }
                
                completionHandler(image)
                print("!! end \(Date().milliStamp)")
            } else {
                UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
                self.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                completionHandler(image)
                print("!! end \(Date().milliStamp)")
            }
        }
    }
    
    class Cell: UICollectionViewCell {
        
        private var label: UILabel?
        
        var value: String? {
            didSet { label?.text = value }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            label = UILabel()
            label?.textColor = .blue
            label?.textAlignment = .center
            label?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
            label?.textColor = UIColor(hex: "757575", alpha: 0.4)
            label?.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label!)
            
            label?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            label?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            label?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            label?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            
            contentView.backgroundColor = .clear
        }
    }
}

extension WatermarkView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = indexPath.item
        let cell = collectionView.dequeueCell(WatermarkView.Cell.self, indexPath: indexPath)
        cell.alpha = transparentValue
        let remainder = item % 10
        switch remainder {
        case 1, 3, 5, 7, 9:
            cell.value = nil
        case 0, 2, 4:
            cell.value = values[0]
        case 6, 8:
            cell.value = values[1]
        default: break
        }
        return cell
    }
}
