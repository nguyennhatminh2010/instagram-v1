//
//  File.swift
//  Instagram
//
//  Created by admin on 16/05/2021.
//

import Firebase

struct Comment {
    var commentText: String
    let profileImageUrl: String
    let uid: String
    let timstamp: Timestamp
    let username: String
    var postId: String
    
    
    init(dictonary: [String: Any]) {
        self.username = dictonary["username"] as? String ?? ""
        self.postId = dictonary["postId"] as? String ?? ""
        self.commentText = dictonary["comment"] as? String ?? ""
        self.profileImageUrl = dictonary["profileImageUrl"] as? String ?? ""
        self.uid = dictonary["uid"] as? String ?? ""
        self.timstamp = dictonary["timstamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
