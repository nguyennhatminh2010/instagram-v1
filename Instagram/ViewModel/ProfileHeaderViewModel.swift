//
//  ProfileHeader.swift
//  Instagram
//
//  Created by admin on 10/05/2021.
//

import Foundation
import UIKit

struct ProfileHeaderViewModel {
    
    // MARK: - Properties
    let user: User
    var fullname: String {
        return user.fullname
    }
    var profileImageUrl: URL {
        return URL(string: user.profileImageUrl)!
    }
    
    var editProfileText: String {
        return user.isCurrentUser ? "Edit Profile" : (user.isFollowed ? "Following" : "Follow")
    }
    
    var editProfileButtonTextcolor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    var editProfileButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStartText(value: user.stat.folllowes, label: "followers")
    }
    
    var numberOfFollowing: NSAttributedString {
        return attributedStartText(value: user.stat.following, label: "following")
    }
    
    var numberOfPost: NSAttributedString {
        return attributedStartText(value: user.stat.post, label: "posts")
    }
    // MARK: - Function
    init(user: User) {
        self.user = user
    }
    
    func attributedStartText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [ .font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }

}
