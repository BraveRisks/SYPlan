//
//  UITableView+Extension.swift
//  SYPlan
//
//  Created by Ray on 2020/10/12.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

extension UITableView {
    
    func addCell<T: UITableViewCell>(_ t: T.Type, isNib: Bool = true) {
        let identifier = String(describing: t)
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
