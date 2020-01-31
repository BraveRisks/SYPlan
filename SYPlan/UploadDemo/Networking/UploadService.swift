//
//  UploadService.swift
//  SYPlan
//
//  Created by Ray on 2018/8/29.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import UIKit

class UploadService {
    private let df = DateFormatter()
    
    var uploadSession: URLSession!
    var activeUpload: [URLSessionTask: UploadTask] = [:]
    
    typealias Completion = (UploadResult?, Error?) -> Void
    
    init() {
        df.dateFormat = "yyyyMMdd_HHmmss"
    }
    
    func upload(_ task: UploadTask, completion: @escaping Completion) {
        let data = task.oriImg.jpegData(compressionQuality: 0.8)!
        let boundary = "Boundary-\(UUID().uuidString)"
        let parameters = ["user": "Ray",
                          "pass": "abcd1234",
                          "mail": "brave2risks@gmail.com",
                          "gender": "true"]
        
        var urlRequest = URLRequest(url: URL(string: "http://10.30.2.77:3001/upload/v1/register")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = createBody(parameters: parameters,
                                         boundary: boundary,
                                         data: data,
                                         mimeType: "image/jpg",
                                         filename: "\(df.string(from: Date()))_\(task.index).jpg")
        
        let sessionTask = uploadSession.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                task.satus = .fail
                task.progress = 0.0
                completion(nil, err)
            } else if let r = response, let res = r as? HTTPURLResponse, res.statusCode == 200 {
                let decoder = JSONDecoder()
                if let data = data, let result = try? decoder.decode(UploadResult.self, from: data) {
                    task.satus = result.status ? .success : .fail
                    task.sendTime = result.status ? String(result.sendTime.split(separator: " ")[1]) : ""
                    completion(result, nil)
                } else {
                    print("JSON Decode Error -->\(String(describing: String(data: data!, encoding: .utf8)))")
                }
            }
        }
        activeUpload[sessionTask] = task
        sessionTask.resume()
    }
    
    func removeTask(_ task: UploadTask) {
        if let index = activeUpload.firstIndex(where: { (arg) -> Bool in return arg.value.index == task.index }) {
            // 當success or fail移除當前任務
            activeUpload.remove(at: index)
            print("Remove activeUpload success.")
        }
    }
    
    private func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        // 其中photo為與後端律定的名稱
        body.appendString("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))

        return body as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
