//
//  PostService.swift
//  Instagram
//
//  Created by admin on 13/05/2021.
//

import UIKit
import Firebase

struct PostService {
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirebaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
            "ownUid": currentUid] as [String: Any]
            let docRef = COLLECTION_POSTS.addDocument(data: data, completion: completion)
            self.updateUserFeedAfterPost(postId: docRef.documentID)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let posts = documents.map({Post(postId: $0.documentID, dictonary: $0.data())})
            completion(posts)
        }
    }
    
    static func fetchPosts(of uid: String, completion: @escaping([Post]) -> Void) {
        let query = COLLECTION_POSTS.whereField("ownUid", isEqualTo: uid)
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            var posts = documents.map({Post(postId: $0.documentID, dictonary: $0.data())})
            completion(posts)
            
            posts.sort { (post1, post2) -> Bool in
                return post1.timstamp.seconds > post2.timstamp.seconds
            }
        }
    }
    
    static func fetchPost(with postId: String, completion: @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            let post = Post(postId: postId, dictonary: data)
            completion(post)
        }
    }
    
    static func likePost(forPost post: Post, completion: @escaping(FirebaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(currentUid).setData([:]) { _ in
            COLLECTION_USERS.document(currentUid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(forPost post: Post, completion: @escaping(FirebaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(currentUid).delete { _ in
            COLLECTION_USERS.document(currentUid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkUserDidLikePost(forPost post: Post, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(currentUid).getDocument { snapshot, error in
            guard let isDidlike = snapshot?.exists else { return }
            completion(isDidlike)
        }
    }
    
    static func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let query = COLLECTION_POSTS.whereField("ownUid", isEqualTo: user.uid)
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            let docsId = documents.map({ $0.documentID })
            docsId.forEach { id in
                if didFollow {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).setData([:])
                } else {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).delete()
                }
            }
        }
    }
    
    static func fetchFeedPosts(completion: @escaping([Post]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts = [Post]()
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ doc in
                fetchPost(with: doc.documentID) { post in
                    posts.append(post)
                    completion(posts)
                }
            })
        }
    }
    
    private static func updateUserFeedAfterPost(postId: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWERS.document(currentUid).collection("user-followers").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { doc in
                COLLECTION_USERS.document(doc.documentID).collection("user-feed").document(postId).setData([:])
            }
            
            COLLECTION_USERS.document(currentUid).collection("user-feed").document(postId).setData([:])
        }
    }
}

