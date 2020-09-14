//
//  ExtensionSequence.swift
//  ExtensionLib
//
//  Created by Ray on 2020/2/19.
//  Copyright © 2020 Ray. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    
    /// 排除重複的值
    /// ```
    /// How to use it ?
    /// let array: [Int] = [1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 5, 6, 6, 7, 7]
    /// array.unique()
    /// print = [1, 2, 3, 4, 5, 6, 7]
    /// ```
    func unique() -> [Iterator.Element] {
        var set: Set<Iterator.Element> = Set()
        return filter { set.insert($0).inserted }
    }
}
