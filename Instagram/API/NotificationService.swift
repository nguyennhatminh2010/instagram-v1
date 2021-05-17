//
//  NotificationService.swift
//  Instagram
//
//  Created by admin on 16/05/2021.
//

import Firebase

struct NotificationService {
    static func uploadNotification(toUid uid: String, profileImageUrl: String, username: String, post: Post? = nil, type: NotificationType) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else {
            print("DEBUG: uid = currentUid")
            return }
        print("DEBUG: Notification")
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": currentUid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "username": username,
                                   "profileImageUrl": profileImageUrl]
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_NOTIFICATIONS.document(currentUid).collection("user-notifications").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let notifications = documents.map({Notification(dictionary: $0.data())})
            completion(notifications)
        }
    }
}
