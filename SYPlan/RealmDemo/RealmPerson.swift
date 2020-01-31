//
//  RealmPerson.swift
//  SYPlan
//
//  Created by Ray on 2019/5/10.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPerson: Object {
    // 類別支援：https://realm.io/docs/swift/latest/#supported-types
    
    @objc dynamic var name: String = ""
    var age: RealmOptional<Int> = RealmOptional<Int>()
    var gender: RealmOptional<Bool> = RealmOptional<Bool>()
    //@objc dynamic var constellations: String? = nil
}
