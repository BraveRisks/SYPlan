//
//  ProfileViewModel.swift
//  SYPlan
//
//  Created by Ray on 2018/8/22.
//  Copyright © 2018年 Sinyi. All rights reserved.

//  Use for Profile data.

import UIKit

// 依照內容去拆分
enum ProfileModelItemType {
    case profile
    case about
    case email
    case friends
}

protocol ProfileModelDataSource {
    var type: ProfileModelItemType { get }
    var sectionTitle: String? { get }
    var rowCount: Int { get }
    var rowHeight: CGFloat { get }
}

class ProfileViewModel: NSObject {
    private(set) var items: [ProfileModelDataSource] = []
    
    var data: Profile? {
        didSet { parseProfileData(data) }
    }
    
    var friends: [Profile.Friend]? {
        didSet { parseProfileFriendsData(friends) }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(profile: Profile) {
        self.init()
        parseProfileData(profile)
    }
    
    private func parseProfileData(_ profile: Profile?) {
        guard let profile = profile else { return }
        if items.count > 0 { items.removeAll() }
        
        items.append(ProfileItem(name: profile.name, photo: profile.photo))
        items.append(AboutItem(desc: profile.about))
        items.append(EmailItem(email: profile.email))
        items.append(FriendsItem(friends: profile.friends))
    }
    
    private func parseProfileFriendsData(_ friends: [Profile.Friend]?) {
        guard let friends = friends else { return }
        
        if let item = items[3] as? FriendsItem {
            for f in friends {
                item.friends.append(Profile.Friend(name: f.name, photo: f.photo, gender: f.gender))
            }
        }
    }
}

// Data Item
class ProfileItem: ProfileModelDataSource {
    var type: ProfileModelItemType {
        return .profile
    }
    
    var sectionTitle: String? {
        return nil
    }
    
    var rowCount: Int {
        return 1
    }
    
    var rowHeight: CGFloat {
        return 120.0
    }
    
    var name: String = ""
    var photo: String = ""
    
    init(name: String, photo: String) {
        self.name = name
        self.photo = photo
    }
}

class AboutItem: ProfileModelDataSource {
    var type: ProfileModelItemType {
        return .about
    }
    
    var sectionTitle: String? {
        return nil
    }
    
    var rowCount: Int {
        return 1
    }
    
    var rowHeight: CGFloat {
        return UITableView.automaticDimension
    }
    
    var desc: String = ""
    
    init(desc: String) {
        self.desc = desc
    }
}

class EmailItem: ProfileModelDataSource {
    var type: ProfileModelItemType {
        return .email
    }
    
    var sectionTitle: String? {
        return nil
    }
    
    var rowCount: Int {
        return 1
    }
    
    var rowHeight: CGFloat {
        return 60.0
    }
    
    var email: String = ""
    
    init(email: String) {
        self.email = email
    }
}

class FriendsItem: ProfileModelDataSource {
    var type: ProfileModelItemType {
        return .friends
    }
    
    var sectionTitle: String? {
        return nil
    }
    
    var rowCount: Int {
        return friends.count
    }
    
    var rowHeight: CGFloat {
        return 60.0
    }
    
    var friends: [Profile.Friend] = []
    
    init(friends: [Profile.Friend]) {
        self.friends = friends
    }
}
