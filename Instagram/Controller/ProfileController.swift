//
//  ProfileController.swift
//  Instagram
//
//  Created by admin on 07/05/2021.
//

import UIKit

class ProfileController: UICollectionViewController {
    // MARK: - Properties
    private var user: User
    private var posts = [Post]()
    let cellIdentifier = "Item Cell"
    let headerCellIdentifier = "Hearder Cell"

    // MARK: - Lifecycle
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts(of: user.uid)
    }
    // MARK: - API
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.fetchUserStats()
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { userStat in
            self.user.stat = userStat
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts(of uid: String) {
        PostService.fetchPosts(of: uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(ProfileItemCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeaderCell.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: headerCellIdentifier)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileItemCell
        let post = posts[indexPath.row]
        cell.viewModel = PostViewModel(post: post)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellIdentifier, for: indexPath) as! ProfileHeaderCell
            cell.viewModel = ProfileHeaderViewModel(user: user)
            cell.delegate = self
        return cell
    }
}
// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feedController.post = posts[indexPath.row]
        navigationController?.pushViewController(feedController, animated: false)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}
// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeaderCell: ProfileHeaderCell, didTapActionButtonFor user: User) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        if user.isCurrentUser {
            print("DEBUG: Show edit profile screen")
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { error in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                
                PostService.updateUserFeedAfterFollowing(user: user, didFollow: false)
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.uploadNotification(toUid: user.uid, profileImageUrl: currentUser.profileImageUrl, username: currentUser.username, type: .follow)
                
                PostService.updateUserFeedAfterFollowing(user: user, didFollow: true)
            }
        }
    }
}

