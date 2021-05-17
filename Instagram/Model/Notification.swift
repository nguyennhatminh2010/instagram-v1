//
//  Notification.swift
//  Instagram
//
//  Created by admin on 16/05/2021.
//

import UIKit
import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like: return " liked your post"
        case .comment: return " commented on your post"
        case .follow: return " started following you"
        }
    }
}

struct Notification {
    let uid: String
    var postId: String?
    var profileImageUrl: String
    var postImageUrl: String?
    let timestamp: Timestamp
    let id: String
    let type: NotificationType
    let username: String
    var userIsFollowed = false
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
