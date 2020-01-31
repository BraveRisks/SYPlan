//
//  QueryService.swift
//  SYPlan
//
//  Created by Ray on 2018/8/17.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import Foundation

class QueryService {
    typealias QueryResult = ([Track]?, String) -> ()
    
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var tracks: [Track] = []
    var errorMessage = ""
    
    func fetchTrackList(query: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(query)"
            
            guard let url = urlComponents.url else { return }
            
            dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                defer { self.dataTask = nil }
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let res = response as? HTTPURLResponse, res.statusCode == 200 {
                    self.parseData(data)
                    DispatchQueue.main.async {
                        completion(self.tracks, self.errorMessage)
                    }
                }
            })
            dataTask?.resume()
        }
    }
    
    private func parseData(_ data: Data) {
        var response: JSONDictionary?
        tracks.removeAll()
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        var index = 0
        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary,
                let previewURLString = trackDictionary["previewUrl"] as? String,
                let previewURL = URL(string: previewURLString),
                let name = trackDictionary["trackName"] as? String,
                let artist = trackDictionary["artistName"] as? String {
                tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
                index += 1
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
}
