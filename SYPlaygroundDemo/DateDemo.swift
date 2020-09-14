import UIKit

//extension Date {
//    
//    enum Format {
//        
//        /// value = yyyyMMdd
//        case yyyyMMdd
//        
//        /// value = yyyy-MM-dd
//        case yyyyMMddHasDash
//        
//        /// value = yyyyMMddHHmm
//        case yyyyMMddHHmm
//        
//        /// value = yyyy-MM-dd HH:mm
//        case yyyyMMddHHmmHasSymbol
//        
//        /// 自定義格式化
//        case custom(format: String)
//        
//        var value: String {
//            switch self {
//            case .yyyyMMdd:
//                return "yyyyMMdd"
//            case .yyyyMMddHasDash:
//                return "yyyy-MM-dd"
//            case .yyyyMMddHHmm:
//                return "yyyyMMddHHmm"
//            case .yyyyMMddHHmmHasSymbol:
//                return "yyyy-MM-dd HH:mm"
//            case .custom(let format):
//                return format
//            }
//        }
//        
//    }
//    
//    /// 秒
//    static let second: TimeInterval = 1
//    
//    /// 分
//    static let minute: TimeInterval = 60 * second
//
//    /// 時
//    static let hour: TimeInterval = 60 * minute
//    
//    /// 天
//    static let day: TimeInterval = 24 * hour
//    
//    /// 將日期轉為DateComponents
//    var dateComponents: DateComponents {
//        let calendar = Calendar.current
//        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
//    }
//    
//    /// 取得當前毫秒級時間戳 - 13位
//    var milliStamp: String {
//        let millisecond = CLongLong(round(timeIntervalSince1970 * 1000))
//        return "\(millisecond)"
//    }
//    
//    /// 建立日期，若其他參數未填入，則預設現在的日期時間
//    /// - Parameters:
//    ///   - year: 年
//    ///   - month: 月
//    ///   - day: 日
//    ///   - hour: 時
//    ///   - minute: 分
//    ///   - second: 秒
//    /// - Returns: 如果無法建立定義的日期，則回傳現在的日期
//    static func create(year: Int? = Date().dateComponents.year,
//                       month: Int? = Date().dateComponents.month,
//                       day: Int? = Date().dateComponents.day,
//                       hour: Int? = Date().dateComponents.hour,
//                       minute: Int? = Date().dateComponents.minute,
//                       second: Int? = Date().dateComponents.second) -> Date {
//        var component = DateComponents()
//        component.calendar = Calendar.current
//        component.year = year
//        component.month = month
//        component.day = day
//        component.hour = hour
//        component.minute = minute
//        component.second = second
//        
//        return Calendar.current.date(from: component) ?? Date()
//    }
//    
//    /// 格式化日期
//    /// - Parameter format: see more Date.Format
//    func string(format: Format) -> String {
//        let df = DateFormatter()
//        df.dateFormat = format.value
//        return df.string(from: self)
//    }
//}
//
//// Unit: second
//var date1 = Date(timeIntervalSince1970: 0)
//var date2 = Date(timeIntervalSince1970: Date.minute)
//
//var date3 = Date(timeIntervalSinceNow: 0)
//var date4 = Date(timeIntervalSinceNow: Date.minute)
//
//var date5 = Date(timeIntervalSinceReferenceDate: 0)
//var date6 = Date(timeIntervalSinceReferenceDate: Date.day)
//
///// 計算兩個日期的間距，result = 86400
//let distance = date5.distance(to: date6)
//
///// 加時間，result = 2020-06-11 10:10 AM
//let newDate = date3.addingTimeInterval(Date.day * 30)
//
///// 從 1970-01-01 00:00:00起，經過幾秒鐘
//let seconds = date3.timeIntervalSince1970
//
///// 建立日期
//let create = Date.create(hour: 20, minute: 46)
//let createStr = create.string(format: .yyyyMMddHHmmHasSymbol)

