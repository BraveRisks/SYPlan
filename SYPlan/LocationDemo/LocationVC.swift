//
//  LocationVC.swift
//  SYPlan
//
//  Created by Ray on 2018/8/15.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit
import CoreLocation

class LocationVC: UIViewController {

    var locationManager: CLLocationManager?
    
    private var mTableView: UITableView!
    private var mLocations: [CLLocation] = []
    private var df: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        setupLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupView() {
        mTableView = UITableView(frame: CGRect.zero, style: .plain)
        mTableView.dataSource = self
        mTableView.delegate = self
        view.addSubview(mTableView)
        mTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: mTableView!, attribute: .top,
                           relatedBy: .equal,
                           toItem: view, attribute: .top,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .leading,
                           relatedBy: .equal,
                           toItem: view, attribute: .leading,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .trailing,
                           relatedBy: .equal,
                           toItem: view, attribute: .trailing,
                           multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: mTableView!, attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view, attribute: .bottom,
                           multiplier: 1.0, constant: 0.0).isActive = true
        
        df.dateFormat = "yyyyMMdd HH:mm:ss"
    }
    
    private func setupLocation() {
        // 取得定位服務是否可用
        guard CLLocationManager.locationServicesEnabled() else {
            print("locationServicesEnabled false")
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
        locationManager?.requestWhenInUseAuthorization()
        
        // 授權順序
        // 1. notDetermined
        // 2. denied or authorizedAlways or authorizedWhenInUse
        
        // 在背景執行下是否繼續取得手機定位資訊
        locationManager?.allowsBackgroundLocationUpdates = true
        if #available(iOS 11.0, *) {
            locationManager?.showsBackgroundLocationIndicator = true
        }
        
        // 取得目前的位置資訊
        if let location = locationManager?.location {
            print("Init Location --> \(location)")
        }
    }
    
    private func goLocationSetting() {
        let ac = UIAlertController(title: "定位權限被拒，請前往設定開啟「定位」服務", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "前往設定", style: .default, handler: { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        ac.addAction(UIAlertAction(title: "關閉", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

extension LocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 取得定位授權權限狀況
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("didChangeAuthorization --> authorizedAlways or authorizedWhenInUse")
            manager.startUpdatingLocation()
        case .denied:
            print("didChangeAuthorization --> denied")
            goLocationSetting()
        case .notDetermined:
            print("didChangeAuthorization --> notDetermined")
        default:
            print("didChangeAuthorization  --> restricted")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 當位置資訊有更新時
        if let location = locations.last {
            print("didUpdateLocations --> \(location)")
            mLocations.append(location)
            mTableView.reloadData()
            mTableView.scrollToRow(at: IndexPath(row: mLocations.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopUpdatingLocation()
            return
        }
    }
}

extension LocationVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let lat = mLocations[index].coordinate.latitude
        let lng = mLocations[index].coordinate.longitude
        cell.textLabel?.text = "\(lat),\(lng)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        cell.textLabel?.textColor = .orange
        
        let speed = mLocations[index].speed
        cell.detailTextLabel?.text = df.string(from: mLocations[index].timestamp) + " , \(speed)mps"
        return cell
    }
}
