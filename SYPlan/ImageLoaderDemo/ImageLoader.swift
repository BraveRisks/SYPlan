//
//  ImageLoader.swift
//  SYPlan
//
//  Created by Ray on 2020/2/25.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

enum ImageLoaderError: Error, CustomStringConvertible {
    
    /// 轉換URL格式錯誤
    case converUrlError
    
    /// 請求取消
    case requestCanceled
    
    /// 回應錯誤
    case responseError(error: Error)
    
    /// 回應資料null
    case responseDataNil
    
    /// 轉換Image錯誤
    case converImageError
    
    var description: String {
        switch self {
        case .converUrlError:
            return "轉換URL格式錯誤"
        case .requestCanceled:
            return "請求取消"
        case .responseError(let error):
            return "回應錯誤 = \(error.localizedDescription)"
        case .responseDataNil:
            return "回應資料null"
        case .converImageError:
            return "轉換Image錯誤"
        }
    }
}

// Reference: https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/
class ImageLoader {
    
    static let share = ImageLoader()
    
    //private var cache: NSCache<NSString, NSData>
    private var session: URLSession
    
    private var loadedImages: [URL: UIImage] = [:]
    private var runningRequests: [UUID: URLSessionDataTask] = [:]
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        
        session = URLSession(configuration: configuration)
        
        //cache = NSCache()
        
        // 設置緩存的數量，若超過則會刪除舊有的資料
        //cache.countLimit = 100
    }
    
    @discardableResult
    public func load(path: String,
                     completion: @escaping ((Result<UIImage, ImageLoaderError>) -> Void)) -> UUID? {
        
        guard let url = URL(string: path) else {
            completion(.failure(.converUrlError))
            return nil
        }
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15)
        request.httpMethod = "GET"
        request.networkServiceType = .background
        
        let uuid = UUID()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            if let error = error, (error as NSError).code == NSURLErrorCancelled {
                DispatchQueue.main.sync { completion(.failure(.requestCanceled)) }
                return
            }
            
            if let error = error {
                DispatchQueue.main.sync { completion(.failure(.responseError(error: error))) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.sync { completion(.failure(.responseDataNil)) }
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.sync { completion(.failure(.converImageError)) }
                return
            }
            
            DispatchQueue.main.sync {
                self.loadedImages[url] = image
                completion(.success(image))
            }
        }

        runningRequests[uuid] = task
        
        task.resume()
        
        return uuid
    }
    
    public func cancelLoad(_ uuid: UUID, _ path: String) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
        print("cancelLoad = \(path)")
    }
}
