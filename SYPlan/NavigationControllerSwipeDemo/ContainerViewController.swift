//
//  ContainerViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/10/16.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum `Type`: CustomStringConvertible {
        
        case ui
        
        case network
        
        case other
        
        case apple
        
        var description: String {
            switch self {
            case .ui:
                return "UI"
            case .network:
                return "Network"
            case .other:
                return "Other"
            case .apple:
                return "New Features"
            }
        }
        
        /// 資料集
        var datas: [Content] {
            switch self {
            case .ui:
                return [.fbWeb, .customCollectionViewLayout, .coreImage,
                        .animationNumber, .qrCode, .waterMark, .font,
                        .cropImage, .saveImage, .googleMap, .flash,
                        .location, .lifeCircle, .tabSwipe]
            case .network:
                return [.upload, .download, .webService, .apiRefresh,
                        .imageLoader]
            case .other:
                return [.fbLogin, .regular, .coreData,
                        .realm, .googleAds, .other,
                        .linkURL, .osLog]
            case .apple:
                return [. coreMLImage, .coreMLText]
            }
        }
        
        enum Content: String {
            
            case fbWeb = "仿FB網頁開啟"
            
            case customCollectionViewLayout = "Custom CollectionView Layout"
            
            case coreImage = "Core Image"
            
            case animationNumber = "Animation Number"
            
            case qrCode = "QR Code"
            
            case waterMark = "浮水印"
            
            case upload = "上傳 Demo"
            
            case download = "下載 Demo"
            
            case webService = "Web Service"
            
            case fbLogin = "FB Login"
            
            case multiCell = "TableView 多類型Cell"
            
            case regular = "Regular Expression"
            
            case coreData = "Core Data"
            
            case realm = "Realm"
            
            case googleAds = "Google Ads"
            
            case coreMLImage = "Core ML Image"
            
            case coreMLText = "Core ML Text"
            
            case other = "Other Demo"
            
            case font = "Font Style"
                        
            case apiRefresh = "Api Refresh"
            
            case cropImage = "Crop Image"
            
            case saveImage = "Save Image"
            
            case imageLoader = "Image Loader"
            
            case linkURL = "Link URL"
            
            case osLog = "OS Log"
        
            case googleMap = "Google Map"
            
            case flash = "Flash View"
            
            case location = "Location"
            
            case lifeCircle = "LifeCirlce"
            
            case tabSwipe = "Tab Swipe"
        }
    }
    
    private var type: Type = .ui
    
    convenience init(type: Type) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        /*
         iPhone 6 Device
         StatusBar Height = 20.0
         TabBarController Height = 49.0
         NavigationController Height = 44.0
         Width = 320.0
         Height = 568.0
         Scale = 2.0
         
         iPhone 6 Simulator (10.3.1、12.4)
         StatusBar Height = 20.0
         TabBarController Height = 49.0
         NavigationController Height = 44.0
         Width = 375.0
         Height = 667.0
         Scale = 2.0
         
         iPhone 6s plus
         StatusBar Height = 20.0
         TabBarController Height = 49.0
         NavigationController Height = 44.0
         Width = 414.0
         Height = 736.0
         Scale = 3.0
         
         iPhone 11 Pro
         StatusBar Height = 44.0
         TabBarController Height = 83.0
         NavigationController Height = 44.0
         Width = 375.0
         Height = 812.0
         
         */
        print("StatusBar Height = \(UIApplication.shared.statusBarFrame.height)")
        
        if let tabHeight = tabBarController?.tabBar.frame.height {
            print("TabBarController Height = \(tabHeight)")
        }
        
        if let navigationHeight = navigationController?.navigationBar.frame.height {
            print("NavigationController Height = \(navigationHeight)")
        }
        
        print("Screen Width = \(UIScreen.width), Height = \(UIScreen.height)")
        print("Screen scale = \(UIScreen.main.scale)")
    }

    private func setup() {
        navigationItem.title = type.description
        
        let spacing: CGFloat = 10.0
        let span = 2
        let screenW = UIScreen.main.bounds.width
        
        let itemW = (screenW - (CGFloat(span + 1) * spacing)) / CGFloat(span)
        let itemSize = CGSize(width: itemW, height: itemW)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = itemSize
        flowLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.addCell(ContainerCell.self, isNib: false)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    class ContainerCell: UICollectionViewCell {
        
        private var label: UILabel?
        
        var data: ContainerViewController.`Type`.Content? {
            didSet { label?.text = data?.rawValue }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        override func layoutSubviews() {
            guard contentView.bounds != .zero else { return }
            let gradient = CAGradientLayer()
            gradient.create(direction: .leftTopToRightBottom,
                            startColor: UIColor(hex: "39ac39"), endColor: UIColor(hex: "8cd98c"),
                            bounds: contentView.bounds)
            contentView.layer.insertSublayer(gradient, at: 0)
            contentView.layer.cornerRadius = 8.0
            contentView.layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            label = UILabel()
            label?.numberOfLines = 0
            label?.textAlignment = .center
            label?.textColor = .white
            label?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
            label?.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label!)
            
            label?.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: 5.0).isActive = true
            label?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: 5.0).isActive = true
            label?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                             constant: -5.0).isActive = true
            label?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                           constant: -5.0).isActive = true
            
            layoutIfNeeded()
        }
    }
}

extension ContainerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return type.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(ContainerCell.self, indexPath: indexPath)
        cell.data = type.datas[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = type.datas[indexPath.item]
        switch content {
        case .fbWeb:
            let vc = FacebookWebDemoViewController(nibName: "FacebookWebDemoViewController", bundle: nil)
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .customCollectionViewLayout:
            let vc = PinterestViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .coreImage:
            let vc = CoreImageViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .animationNumber:
            let vc = CADisplayLinkDemoViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .qrCode:
            let vc = QRCodeDemoViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .waterMark:
            let vc = WatermarkDemoViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .upload:
            let vc = UploadDemoController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .download:
            let vc = DownloadDemoController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .webService:
            let vc = WebServiceDemoVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .fbLogin:
            let vc = FacebookLoginDemoViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .multiCell: break
        case .regular:
            let vc = RegularExpressionViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .coreData:
            let vc = CoreDataViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .realm:
            let vc = RealmViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .googleAds:
            let vc = GoogleAdDemoViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .coreMLImage:
            let vc = CoreMLVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .coreMLText:
            let vc = CoreMLTextVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .other:
            let vc = OtherDemoVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .font:
            let vc = FontViewController()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .apiRefresh:
            let vc = ApiDemoVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .cropImage:
            let vc = CropImageDemoVC(nibName: "CropImageDemoVC", bundle: nil)
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .saveImage:
            let vc = SaveImageVC(nibName: "SaveImageVC", bundle: nil)
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .imageLoader:
            let vc = ImageLoaderDemoVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .linkURL:
            let vc = LinkDemoVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .osLog:
            let vc = OSLogDemoVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .googleMap:
            let vc = GoogleMapDemoVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .flash:
            let vc = FlashDemoVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .location:
            let vc = LocationVC()
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .lifeCircle:
            let vc = LifeCircleDemoVC()
            vc.value = "didSet"
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .tabSwipe:
            let vc = TabSwipeDemoVC(nibName: "TabSwipeDemoVC", bundle: nil)
            vc.title = content.rawValue
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // If you want to doing same action in `UITableView`
    // You need implement
    // func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath:                     IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    //     reutrn nil
    // }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        print("ContextMenuConfigurationForItemAt = \(indexPath) ; \(point)")
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
            
            // 顯示預覽時的ViewController，並會觸發Life circle
            // 當為nil時，則顯示Item的樣式，並且無法上滑、下滑離開，只能點擊半透明地方離開
            return PinterestViewController()
        }) { (elements) -> UIMenu? in
            let share = UIAction(title: "分享",
                                 image: UIImage(systemName: "square.and.arrow.up"))
            { action in
                print("ContextMenu 分享")
            }

            let rename = UIAction(title: "複製",
                                  image: UIImage(systemName: "doc.on.doc"))
            {
              action in
                print("ContextMenu 複製")
            }

            let delete = UIAction(title: "刪除",
                                  image: UIImage(systemName: "trash"),
                                  attributes: .destructive)
            { action in
                print("ContextMenu 刪除")
            }

            // Create a UIMenu with all the actions as children
            return UIMenu(title: "選單",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [share, rename, delete])
        }
        
        return configuration
    }
}
