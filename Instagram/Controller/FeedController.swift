//
//  FeedController.swift
//  Instagram
//
//  Created by admin on 07/05/2021.
//

import UIKit
import Firebase

class FeedController: UICollectionViewController {
    // MARK: - Properties
    let reuseIdentifier = "cell"
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var post: Post?
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
        if let post = post {
            checkIfUSerDidLikePosts()
        }
    }
    
    // MARK: - Helpers

    func configureUI() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(handleLogout))
        }
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresherAction), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    // MARK: - API
    func fetchPosts() {
        guard post == nil else { return }
//        PostService.fetchPosts { posts in
//            self.posts = posts
//            self.checkIfUSerDidLikePosts()
//            self.collectionView.refreshControl?.endRefreshing()
//        }
        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.checkIfUSerDidLikePosts()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUSerDidLikePosts() {
        if let post = post {
            PostService.checkUserDidLikePost(forPost: post) { didLike in
                self.post?.didLike = didLike
            }
        } else {
            self.posts.forEach { post in
                PostService.checkUserDidLikePost(forPost: post) { didLike in
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                        self.posts[index].didLike = didLike
                    }
                }
            }
        }
    }
    // MARK: - Actions
    
    @objc func handleLogout() {
        AuthService.logout()
        DispatchQueue.main.async {
            let login = LoginController()
            login.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: login)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
        }
    }
    
    @objc func handleRefresherAction() {
        posts.removeAll()
        fetchPosts()
    }
}

    // MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = self.post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        return cell
    }
}
    
// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = width + 166
        return CGSize(width: width, height: height)
    }
}
// MARK: - FeedCellDelegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfile uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentForPost post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, wantsToLikePost post: Post) {
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            PostService.unlikePost(forPost: post) { _ in
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(forPost: post) { _ in
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                guard let tab = self.tabBarController as? MainTabController else { return }
                guard let user = tab.user else { return }
                NotificationService.uploadNotification(toUid: post.ownerUid, profileImageUrl: user.profileImageUrl, username: user.username, post: post, type: .like)
            }
        }
    }
}




