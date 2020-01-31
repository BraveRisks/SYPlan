//
//  PinterestViewController.swift
//  SYPlan
//
//  Created by Ray on 2018/10/30.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class PinterestViewController: UIViewController {
    
    private var mCollectionView: UICollectionView!
    
    private lazy var mPinterestLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.delegate = self
        return layout
    }()
    
    private lazy var mCardLayout: CardLayout = {
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
            datas.append(Pinterest(image: "photo_\(i+1)", title: "美麗的女孩兒-\(i+1)"))
        }
        
        mCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: mPinterestLayout)
        //mCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: mCardLayout)
        mCollectionView.addCell(PinterestCollectionCell.self)
        mCollectionView.showsVerticalScrollIndicator = false
        mCollectionView.backgroundColor = .white
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mCollectionView)
        
        NSLayoutConstraint.activate([
            mCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            mCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            mCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            mCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
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
