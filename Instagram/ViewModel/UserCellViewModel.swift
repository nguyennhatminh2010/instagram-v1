//
//  UserCellViewModel.swift
//  Instagram
//
//  Created by admin on 11/05/2021.
//

import Foundation

struct UserCellViewModel {
    // MARK: - Properties
    
    private let user: User
    var username: String {
        return user.username
    }
    var fullname: String {
        return user.fullname
    }
    var profileImageView: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
    }
}
