//
//  CommentService.swift
//  Instagram
//
//  Created by admin on 16/05/2021.
//

import Firebase

struct CommentService {
    static func uploadComment(comment: String, postId: String, user: User, completion: @escaping(FirebaseCompletion)) {
        let data: [String: Any] = ["uid": user.uid,
                                   "username": user.username,
                                   "profileImageUrl" : user.profileImageUrl,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date())]
        COLLECTION_POSTS.document(postId).collection("comments").addDocument(data: data,
                                                                             completion: completion)
        
    }
    
    static func fetchComments(for postId: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        let query = COLLECTION_POSTS.document(postId).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictonary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        }
    }
}
