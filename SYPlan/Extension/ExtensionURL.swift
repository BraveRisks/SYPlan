//
//  ExtensionURL.swift
//  SYPlan
//
//  Created by Ray on 2018/8/24.
//  Copyright © 2018年 Sinyi. All rights reserved.
//  Swift version：4.1

import Foundation

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
