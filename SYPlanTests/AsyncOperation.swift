//
//  AsyncOperation.swift
//  SYPlanTests
//
//  Created by Ray on 2020/10/12.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import Foundation

struct AsyncOperation<Value> {
    
    let queue: DispatchQueue = .main
    let closure: () -> Value

    func perform(then handler: @escaping (Value) -> Void) {
        queue.async {
            let value = self.closure()
            handler(value)
        }
    }
}
