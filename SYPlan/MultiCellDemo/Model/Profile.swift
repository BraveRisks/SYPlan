//
//  Profile.swift
//  SYPlan
//
//  Created by Ray on 2018/8/22.
//  Copyright © 2018年 Sinyi. All rights reserved.
//

import Foundation

open class Profile: Codable {
    var name: String
    var photo: String
    var about: String
    var email: String
    var friends: [Friend]
    
    init(name: String, photo: String, about: String, email: String, friends: [Friend]) {
        self.name = name
        self.photo = photo
        self.about = about
        self.email = email
        self.friends = friends
    }
    
    class Friend: Codable {
        var name: String
        var photo: String
        var gender: Bool
        
        init(name: String, photo: String, gender: Bool) {
            self.name = name
            self.photo = photo
            self.gender = gender
        }
    }
}
