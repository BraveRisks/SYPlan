//
//  ImageLoader.swift
//  SYPlan
//
//  Created by Ray on 2020/2/25.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

struct ImageLoader {
    
    static let share = ImageLoader()
    
    private var cache: NSCache<NSString, NSData>
    private var session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        
        session = URLSession(configuration: configuration)
        
        cache = NSCache()
        
        // 設置緩存的數量，若超過則會刪除舊有的資料
        cache.countLimit = 100
    }
    
    public func load(path: String,
                     completion: @escaping ((_ image: UIImage?, _ path: String) -> Swift.Void)) {
        guard let url = URL(string: path) else { return completion(nil, path) }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15)
        request.httpMethod = "GET"
        request.networkServiceType = .background
        
        DispatchQueue.global(qos: .background).async {
            if let data = self.cache.object(forKey: path as NSString),
                let image = UIImage(data: data as Data) {
                //print("ImageLoader use cache for \(path)")
                DispatchQueue.main.sync { completion(image, path) }
                return
            }
            
            let task = self.session.dataTask(with: request) { (data, response, error) in
                guard error.isNil else {
                    DispatchQueue.main.sync { completion(nil, path) }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.sync { completion(nil, path) }
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    DispatchQueue.main.sync { completion(nil, path) }
                    return
                }
                
                //print("ImageLoader use request for \(path)")
                DispatchQueue.main.sync {
                    self.cache.setObject(data as NSData, forKey: path as NSString)
                    completion(image, path)
                }
            }

            task.resume()
        }
    }
}
