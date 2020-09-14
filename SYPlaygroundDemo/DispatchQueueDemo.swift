//
//  DispatchQueueDemo.swift
//  ExtensionLib
//
//  Created by Ray on 2020/7/27.
//  Copyright © 2020 Ray. All rights reserved.
//

import Foundation

// Reference:
// 1. https://www.appcoda.com.tw/ios-concurrency/
// 2. https://stackoverflow.com/questions/54058634/what-are-the-benefits-of-using-dispatchworkitem-in-swift

// 全局線程
// DispatchQoS property
// 1. background
// 2. utility
// 3. `default`
// 4. userInitiated
// 5. userInteractive
// 6. unspecified
//let global = DispatchQueue.global(qos: .default)
//
// 並行隊列
//global.async {
//    sleep(1)
//    print("async index = 1")
//}
//
//print("async divider 1")
//
//global.async {
//    print("async index = 2")
//}
//
//print("async divider 2")
//
//global.async {
//    sleep(2)
//    print("async index = 3")
//}
//
//print("async divider 3")
//
//
//
//// ========== Global Sync =========
//
//
//
//let global2 = DispatchQueue.global()
//
// 串行隊列
//global2.sync {
//    sleep(4)
//    print("sync index = 1")
//}
//
//print("sync divider 1")
//
//global2.sync {
//    print("sync index = 2")
//}
//
//print("sync divider 2")
//
//global2.sync {
//    sleep(2)
//    print("sync index = 3")
//}
//
//print("sync divider 3")
//
//
//
// ========== OperationQueue =========
//
//
//
//let operationQueue = OperationQueue()
//
// 並行隊列
//operationQueue.addOperation {
//    sleep(1)
//    print("OperationQueue index = 1")
//}
//operationQueue.addOperation {
//    sleep(5)
//    print("OperationQueue index = 2")
//}
//operationQueue.addOperation {
//    print("OperationQueue index = 3")
//}
//
//
//
// ========== OperationQueue + BlockOperation =========
//
//
//
//let operationQueue1 = OperationQueue()
//
// example2: 模擬依序依賴前個任務的執行狀況，來達到串行隊列
//let block1 = BlockOperation()
//block1.queuePriority = .veryLow
//block1.addExecutionBlock {
//    sleep(3)
//    print("BlockOperation 1 trigger.")
//}
//
//block1.completionBlock = {
//    print("BlockOperation 1 comletion.")
//}
//
//let block2 = BlockOperation()
//block2.queuePriority = .high
//
// 依賴block1，也就是block1完成後才執行block2
//block2.addDependency(block1)
//
//block2.addExecutionBlock {
//    print("BlockOperation 2 trigger.")
//}
//
//block2.completionBlock = {
//    print("BlockOperation 2 comletion.")
//}
//
// 執行任務
//operationQueue1.addOperation(block1)
//operationQueue1.addOperation(block2)
//
// example2: 模擬依序依賴前個任務的執行狀況，來達到串行隊列
//var ary: [BlockOperation] = []
//for i in 0 ..< 10 {
//    let block = BlockOperation()
//    block.queuePriority = .veryLow
//    block.addExecutionBlock {
//        if i % 3 == 0 { sleep(2) }
//
//    }
//
//    block.completionBlock = {
//        print("\(i) completion.")
//    }
//
//    if ary.isEmpty == false {
//        block.addDependency(ary[i - 1])
//    }
//
//    ary.append(block)
//    operationQueue1.addOperation(block)
//}
//
// Cancel
//operationQueue1.cancelAllOperations()
//
//
//
// ========== DispatchSemaphore =========
// Reference:
// 1. https://www.jianshu.com/p/ce06c7917771
// 2. https://riptutorial.com/ios/example/28284/dispatch-semaphore
//

//label     ：隊列的標識符
//qos       ：隊列的quality of service。用來指明隊列的`重要性`
//   1. User Interactive：和用戶交互相關，比如動畫等等優先級最高。比如用戶連續拖拽的計算
//   2. User Initiated  ：需要立刻的結果，比如push一個ViewController之前的數據計算
//   3. Utility         ：可以執行很長時間，再通知用戶結果。比如下載一個文件，給用戶下載進度。
//   4. Background      ：用戶不可見，比如在後台存儲大量數據
//attributes：隊列的屬性。類型是DispatchQueue.Attributes，是一個結構體，遵循了協議OptionSet。意味著你可以這樣傳入第一個參數[.option1,.option2]
//autoreleaseFrequency：自動釋放。有些隊列是會在執行完任務後自動釋放的，有些比如Timer等是不會自動釋放的，是需要手動釋放。
//
//let currentQueue = DispatchQueue(label: "tw.brave2risks.currentQueue",
//                                 qos: .default,
//                                 attributes: .concurrent,
//                                 autoreleaseFrequency: .workItem,
//                                 target: nil)
//
//let semaphore = DispatchSemaphore(value: 1)
//for i in 0 ..< 5 {
//    currentQueue.async {
//        semaphore.wait()
//        sleep(2)
//        print("Semaphore index = \(i)")
//        semaphore.signal()
//    }
//}
