//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by admin on 16/05/2021.
//

import UIKit

struct NotificationViewModel {
    var notification: Notification
    var profileImageUrl: URL? {
        return URL(string: notification.profileImageUrl)
    }
    var postImageUrl: URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    var notificationMessage: NSAttributedString {
        let attributedText = NSMutableAttributedString(string: notification.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: notification.type.notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "  \(timestampString ?? "")" , attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    var shouldHidenFollowButton: Bool {
        return notification.type != .follow
    }
    var followButtonText: String {
        return notification.userIsFollowed ? "Following" : "Follow"
    }
    var followButtonBackground: UIColor {
        return notification.userIsFollowed ? .white : .systemBlue
    }
    var followButtonTextColor: UIColor {
        return notification.userIsFollowed ? .black : .white
    }
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: notification.timestamp.dateValue(), to: Date()) ?? "  2m"
    }
    
    init(notification: Notification) {
        self.notification = notification
    }
    
}
