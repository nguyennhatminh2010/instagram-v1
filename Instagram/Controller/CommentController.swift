//
//  CommentController.swift
//  Instagram
//
//  Created by admin on 15/05/2021.
//

import UIKit


class CommentController: UICollectionViewController {
    // MARK: - Properties
    private let post: Post
    private var comments = [Comment]()
    private let reuseIdentifier = "CommentCell"

    private lazy var commentTextField: CommentInputAccesoryTextView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryTextView(frame: frame)
        cv.delegate = self
        return cv
    }()
    // MARK: - Lifecycle
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override var inputAccessoryView: UIView? {
        get {
            return commentTextField
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    // MARK: - API
    func fetchComments() {
        CommentService.fetchComments(for: post.postId) { comments in
            self.comments = comments
            self.collectionView.reloadData()
            print(comments.count)
        }
    }
    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
}
// MARK: - UICollectionViewDatasource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }
}
// MARK: - CommentInputAccesoryTextViewDelegate
extension CommentController: CommentInputAccesoryTextViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryTextView, wantsToUploadComment comment: String) {
        
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        self.showLoader(true)
        
        CommentService.uploadComment(comment: comment, postId: post.postId, user: currentUser) { error in
            self.showLoader(false)
            inputView.clearCommentTextView()
            NotificationService.uploadNotification(toUid: self.post.ownerUid, profileImageUrl: currentUser.profileImageUrl, username: currentUser.username, post: self.post, type: .comment)
        }
    }
}
