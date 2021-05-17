//
//  AuthService.swift
//  Instagram
//
//  Created by admin on 09/05/2021.
//

import UIKit
import Firebase

struct AuthCredential {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign up")
        }
    }
    
    static func login(withEmail email: String, and password: String, completion: AuthDataResultCallback?) {
        
    Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credential: AuthCredential, completion: @escaping(Error?) -> Void) {
        
        ImageUploader.uploadImage(image: credential.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (authResult, error) in
                if let e = error {
                    print("Something wrong while creating new user \(e.localizedDescription)")
                    return
                }
                
                guard let uid = authResult?.user.uid else { return }
                
                let data: [String: Any] = ["email": credential.email,
                                           "fullname": credential.fullname,
                                           "profileImageUrl": imageUrl,
                                           "uid": uid,
                                           "username": credential.username]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
