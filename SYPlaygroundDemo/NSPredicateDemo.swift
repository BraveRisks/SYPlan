import UIKit
import Foundation

// 官方文檔教學 👉🏻 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html#//apple_ref/doc/uid/TP40001798-SW1

// 利用NSPredicate篩選
//let arr: [String] = ["王大偉", "🙋🏻‍♂️Ray", "Jane", "jack", "陳小春", "賈靜雯", "Rain", "Frank",
//                     "🙋🏻‍♂️周偉", "林大飛", "David", "王小明", "Peter", "郭明", "林燕生", "Aida🙋🏻‍♀️"]
//var filter: [String] = []
//
//// `SELF` means each element in the array
//let predicate1 = NSPredicate(format: "SELF CONTAINS %@", "🙋🏻‍♂️")
//
//// the evaluate function will return true if the element satisfy the predicate,
//// otherwise false
//filter = arr.filter({ name in predicate1.evaluate(with: name) })
//print("filter 👉🏻 \(filter)")
//
//// 搜尋開頭為`王`的姓名
//let beginPredicate = NSPredicate(format: "SELF BEGINSWITH %@", "王")
//filter = arr.filter({ name in beginPredicate.evaluate(with: name) })
//print("filter 👉🏻 \(filter)")
//
//// 搜尋開頭為`j`的姓名，但不區分大小寫
//// [c] 👉🏻 case-insensitive
//let ignorePredicate = NSPredicate(format: "SELF BEGINSWITH[c] %@", "j")
//filter = arr.filter({ name in ignorePredicate.evaluate(with: name) })
//print("filter 👉🏻 \(filter)")
//
//// 搜尋結尾為`🙋🏻‍♀️`的姓名
//let endPredicate = NSPredicate(format: "SELF ENDSWITH %@", "🙋🏻‍♀️")
//filter = arr.filter({ name in endPredicate.evaluate(with: name) })
//print("filter 👉🏻 \(filter)")
//
//
//let arr2: [Int] = [1, 8, 16, 30, 55, 9, 3, 60]
//// 搜尋`id`在上列的數字
//let predicate2 = NSPredicate(format: "id IN %@", argumentArray: arr2)
//// 搜尋`id`不在上列的數字
//let predicate3 = NSPredicate(format: "NOT (id IN %@)", argumentArray: arr2)
//
//
//// 搜尋`img*.png`的檔名
//// * 👉🏻 任意字元(zero to more character)
//let arr3: [String] = ["img.png", "img1.png", "img2.png", "img10.png", "img100.png",
//                      "img200.txt", "img300.csv"]
//let likePredicate = NSPredicate(format: "SELF LIKE %@", "img*.png")
//filter = arr3.filter({ name in likePredicate.evaluate(with: name) })
//print("filter 👉🏻 \(filter)")
//
//// 搜尋`img*.png`的檔名
//// ? 👉🏻 任意字元(exactly once character)
//let onePredicate = NSPredicate(format: "SELF LIKE %@", "img?.png")
//filter = arr3.filter({ name in onePredicate.evaluate(with: name) })
//print("filter 👉🏻 \(filter)")
//
//// 搜尋`img\\d{2,3}.[a-z]{3}`的檔名
//// 利用Regular Expression
//let regexPredicate = NSPredicate(format: "SELF MATCHES %@", "img\\d{2,3}.[a-z]{3}")
//filter = arr3.filter({ name in regexPredicate.evaluate(with: name) })
//print("filter 👉🏻 \(filter)")
//
//
//var ary1 = [1,6,5,4,3,8,2,9,10]
//ary1.sort { $1 > $0 }
//print("\(ary1)")
