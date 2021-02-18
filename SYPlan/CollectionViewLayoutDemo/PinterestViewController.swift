//
//  PinterestViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/10/30.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class PinterestViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private lazy var pinterestLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.delegate = self
        return layout
    }()
    
    private lazy var cardLayout: CardLayout = {
        let layout = CardLayout()
        return layout
    }()
    
    private var datas: [Pinterest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("PinterestViewController viewDidLoad")
    }
        
    deinit {
        print("\(self) deinit")
    }
    
    private func setup() {
        view.backgroundColor = .white

        for i in 0 ..< 20 {
            datas.append(Pinterest(image: "photo_\(i + 1)", title: "美麗的女孩兒-\(i + 1)"))
        }

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: pinterestLayout)
        //collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cardLayout)
        collectionView.addCell(PinterestCollectionCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // AutoLayout
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
    }
}

extension PinterestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(PinterestCollectionCell.self, indexPath: indexPath)
        cell.data = datas[indexPath.row]
        return cell
    }
}

extension PinterestViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return (indexPath.row % 4 == 0 || indexPath.row % 4 == 3) ? 180.0 : 200.0
    }
}
