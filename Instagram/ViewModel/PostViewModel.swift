//
//  PostViewModel.swift
//  Instagram
//
//  Created by admin on 14/05/2021.
//

import Firebase
import UIKit

struct PostViewModel {
    
    var post: Post
    var caption: String {
        return post.caption
    }
    var postImageView: URL? {
        return URL(string: post.imageUrl)
    }
    var likes: Int {
        return post.likes
    }
    var ownerUid: String {
        return post.ownerUid
    }
    var postLikeLabel: String {
        return post.likes <= 1 ? "\(likes) like" : "\(likes) likes" 
    }
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    var likeButtonImage: UIImage {
        return post.didLike ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected")
    }
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.timstamp.dateValue(), to: Date())
    }

    init(post: Post) {
        self.post = post
    }
}
