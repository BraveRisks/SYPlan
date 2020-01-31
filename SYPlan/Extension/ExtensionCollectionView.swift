//
//  ExtensionCollectionView.swift
//  SYPlan
//
//  Created by Ray on 2019/10/17.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//

import UIKit

extension UITableView {
    func addCell<T: UITableViewCell>(_ t: T.Type, isNib: Bool = true) {
        let identifier = String(describing: t)
        print("identifier --> \(identifier)")
        if isNib {
            self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        } else {
            self.register(t, forCellReuseIdentifier: identifier)
        }
    }
    
    func dequeueCell<T: UITableViewCell>(_ t: T.Type, indexPath: IndexPath) -> T {
        let identifier = String(describing: t)
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    func addCell<T: UICollectionViewCell>(_ t: T.Type, isNib: Bool = true) {
        let identifier = String(describing: t)
        if isNib {
            self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        } else {
            self.register(t, forCellWithReuseIdentifier: identifier)
        }
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ t: T.Type, indexPath: IndexPath) -> T {
        let identifier = String(describing: t)
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
