// KKBOX Test Solution
//func solution(number: Int) -> Int {
//    if number < 0 { return 0 }
//
//    let origin = String(number)
//    let contenZeroArray = origin.filter { $0 == "0" }
//    let zeroCount = contenZeroArray.count
//
//    let denominator = getP(origin.count, zeroCount: zeroCount)
//    
//    var didCheck = [Character]()
//    var repeatArray = [Int]()
//    for character in origin {
//        if !didCheck.contains(character) {
//            let repeatCount = origin.filter{ $0 == character }.count
//            if repeatCount > 1 { repeatArray.append(repeatCount) }
//            didCheck.append(character)
//        }
//    }
//
//    var numerator = 0
//    for count in repeatArray {
//        let tempalate = getP(count)
//        if numerator == 0 {
//            numerator = tempalate
//        } else {
//            numerator = numerator * tempalate
//        }
//    }
//    numerator = numerator == 0 ? 1 : numerator
//    return denominator / numerator
//}
//
//func getP(_ number: Int, zeroCount: Int = 0) -> Int {
//    if zeroCount > number { return 0 }
//    var caculateNumber = number - zeroCount
//    for index in 1 ... number - 1 {
//        caculateNumber = caculateNumber * (number - index)
//    }
//    return caculateNumber
//}
//
//solution(number: 1610)
