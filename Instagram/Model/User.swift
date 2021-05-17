//
//  User.swift
//  Instagram
//
//  Created by admin on 10/05/2021.
//

import Foundation
import FirebaseAuth

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let uid: String
    let username: String
    var isFollowed = false
    var isCurrentUser: Bool {
        return Auth.auth().currentUser!.uid == uid
    }
    var stat: UserStat!
    
    init(dictonary: [String: Any]) {
        self.email = dictonary["email"] as? String ?? ""
        self.fullname = dictonary["fullname"] as? String ?? ""
        self.profileImageUrl = dictonary["profileImageUrl"] as? String ?? ""
        self.uid = dictonary["uid"] as? String ?? ""
        self.username = dictonary["username"] as? String ?? ""
        self.stat = UserStat(folllowes: 0, following: 0, post: 0)
    }
}

struct UserStat {
    var folllowes: Int
    var following: Int
    var post: Int
}
