//
//  File.swift
//  Instagram
//
//  Created by admin on 14/05/2021.
//

import Firebase

struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timstamp: Timestamp
    var postId: String
    var didLike: Bool = false
    var username: String
    
    init(postId: String, dictonary: [String: Any]) {
        self.postId = postId
        self.username = dictonary["username"] as? String ?? ""
        self.caption = dictonary["caption"] as? String ?? ""
        self.likes = dictonary["likes"] as? Int ?? 0
        self.imageUrl = dictonary["imageUrl"] as? String ?? ""
        self.ownerUid = dictonary["ownUid"] as? String ?? ""
        self.timstamp = dictonary["timstamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
