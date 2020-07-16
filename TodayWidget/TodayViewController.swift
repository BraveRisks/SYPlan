//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Ray on 2020/6/30.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding {
     
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMinMaxLabel: UILabel!
    
    private var locationManager: CLLocationManager?
    private var location: CLLocation?
    
    private var session: URLSession!
    
    /// 超時時間限制，value = 30
    private let timeout: TimeInterval = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        resetContent()
        
        if #available(iOSApplicationExtension 10.0, *) {
            // 設定Widget右側有伸縮的icon，[.compact] 固定大小 [.expanded] 可伸縮
            extensionContext?.widgetLargestAvailableDisplayMode = .compact
        }
        
        // 取得定位服務是否可用
        guard CLLocationManager.locationServicesEnabled() else {
            resetContent()
            return
        }
        
        locationManager = CLLocationManager()
        
        // 設定位置的準確性
        // 1. kCLLocationAccuracyBestForNavigation
        // 2. kCLLocationAccuracyBest
        // 3. kCLLocationAccuracyNearestTenMeters
        // 4. kCLLocationAccuracyHundredMeters
        // 5. kCLLocationAccuracyKilometery
        // 6. kCLLocationAccuracyThreeKilometers
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // 設定最小的更新距離 單位：米(m)
        locationManager?.distanceFilter = kCLDistanceFilterNone
        locationManager?.delegate = self
        
        // 授權順序
        // 1. notDetermined
        // 2. denied or authorizedAlways or authorizedWhenInUse
        locationManager?.requestWhenInUseAuthorization()
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(goSYPlanApp(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func resetContent() {
        cityLabel.text = "--"
        descriptionLabel.text = """
        --
        濕度：--％
        大氣壓力：-- hPa
        """
        tempLabel.text = "--˚"
        tempMinMaxLabel.text = "--˚ / --˚"
    }
    
    private func setCurrentContent(with weather: Weather) {
        cityLabel.text = weather.city
        
        if let info = weather.infos?.last,
            let main = weather.main {
            
            descriptionLabel.text = """
            \(info.description)
            濕度：\(main.humidity)％
            大氣壓力：\(main.pressure) hPa
            """
            tempLabel.text = "\(lround(main.temp))˚"
            tempMinMaxLabel.text = "\(lround(main.tempMin))˚ / \(lround(main.tempMax))˚"
        }
    }
    
    /// 取得目前的天氣
    /// - Parameter location: 目前經緯度
    private func fetchCurrentWeather(from location: CLLocation) {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        config.networkServiceType = .background
        config.httpMaximumConnectionsPerHost = 1
        session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        
        let weatherUrl = """
        http://api.openweathermap.org/data/2.5/weather?appid=32be38731000e42f21c4a11e721f168f&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&lang=zh_tw&units=metric
        """
        
        let url = URL(string: weatherUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.networkServiceType = .background
        
        let task = session.dataTask(with: request) {
            [weak self] (data, response, error) in
            
            guard error == nil else {
                DispatchQueue.main.async { self?.resetContent() }
                return
            }
            
            guard let res = response as? HTTPURLResponse,
                res.statusCode == 200 else {
                DispatchQueue.main.async { self?.resetContent() }
                return
            }
            
            let decoder = JSONDecoder()
            guard let data = data,
                let weather = try? decoder.decode(Weather.self, from: data)
            else {
                DispatchQueue.main.async { self?.resetContent() }
                return
            }
            
            DispatchQueue.main.async { self?.setCurrentContent(with: weather) }
        }
        
        task.resume()
    }
    
    @objc private func goSYPlanApp(_ gesture: UITapGestureRecognizer) {
        guard let url = URL(string: "syplan://routes?page=regular") else {
            return
        }
        
        extensionContext?.open(url, completionHandler: nil)
    }
    
    /// 更新UI
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        if let _ = location {
            completionHandler(.newData)
        } else {
            resetContent()
            completionHandler(.failed)
        }
    }
    
    /// 設定Widget伸縮時的尺寸
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
                
        switch activeDisplayMode {
        case .expanded:
            preferredContentSize = CGSize(width: maxSize.width, height: 200)
        case .compact:
            preferredContentSize = maxSize
        @unknown default:
            fatalError("activeDisplayMode no this choose.")
        }
    }
}

extension TodayViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 取得定位授權權限狀況
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            resetContent()
        case .notDetermined:
            resetContent()
        default:
            resetContent()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 當位置資訊有更新時
        if let location = locations.last {
            fetchCurrentWeather(from: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopUpdatingLocation()
            resetContent()
            return
        }
    }
}

// MARK: Weather model
struct Weather: Decodable {
    
    var city: String
    
    var main: Main?
    
    var infos: [Info]?
    
    private enum CodingKeys: String, CodingKey {
        case city = "name"
        case main = "main"
        case info = "weather"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decodeIfPresent(String.self, forKey: .city) ?? "--"
        main = try container.decodeIfPresent(Main.self, forKey: .main)
        infos = try container.decodeIfPresent([Info].self, forKey: .info)
    }
    
    struct Main: Decodable {
        
        /// 目前溫度
        var temp: Double
        
        /// 當日最低溫
        var tempMin: Double
        
        /// 當日最高溫
        var tempMax: Double
        
        /// 氣壓
        var pressure: Int
        
        /// 濕度
        var humidity: Int
        
        private enum CodingKeys: String, CodingKey {
            case temp = "temp"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure = "pressure"
            case humidity = "humidity"
        }
                
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            temp = try container.decodeIfPresent(Double.self, forKey: .temp) ?? 0
            tempMin = try container.decodeIfPresent(Double.self, forKey: .tempMin) ?? 0
            tempMax = try container.decodeIfPresent(Double.self, forKey: .tempMax) ?? 0
            pressure = try container.decodeIfPresent(Int.self, forKey: .pressure) ?? 0
            humidity = try container.decodeIfPresent(Int.self, forKey: .humidity) ?? 0
        }
    }
    
    struct Info: Decodable {
        
        /// 天氣描述(英文)
        var main: String
        
        /// 天氣描述(中文)
        var description: String
        
        /// 天氣圖示ㄉ代號
        var icon: String
        
        private enum CodingKeys: String, CodingKey {
            case main = "main"
            case description = "description"
            case icon = "icon"
        }
                
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            main = try container.decodeIfPresent(String.self, forKey: .main) ?? "--"
            description = try container.decodeIfPresent(String.self,
                                                        forKey: .description) ?? "--"
            icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? "--"
        }
    }
}

extension Double {
    
    /// 取小數點第n位 default roundingMode：.down
    /// ```
    /// How to use：
    /// 10.48989.round(to: 1)  result：10.4
    /// 10.48989.round(to: 2)  result：10.48
    /// 10.48989.round(to: 3)  result：10.489
    /// 10.48989.round(to: 4)  result：10.4898 ~= 10.489799999999999
    /// ```
    /// - Parameters:
    ///   - n: 取小數點第幾位
    ///   - roundingMode: .down(無條件捨去), .up(無條件進位), .plain(4捨5入), .bankers
    /// - Returns: double
    func round(to n: Int, roundingMode: NSDecimalNumber.RoundingMode = .down) -> Double {
        var result = Decimal()
        var value = Decimal(self)
        NSDecimalRound(&result, &value, n, roundingMode)
        return NSDecimalNumber(decimal: result).doubleValue
    }
}
