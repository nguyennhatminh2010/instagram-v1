//
//  FeedCell.swift
//  Instagram
//
//  Created by admin on 08/05/2021.
//

import UIKit
import SDWebImage

protocol  FeedCellDelegate: class {
    func cell(_ cell: FeedCell, wantsToShowCommentForPost post: Post)
    func cell(_ cell: FeedCell, wantsToLikePost post: Post)
    func cell(_ cell: FeedCell, wantsToShowProfile uid: String)
}
class FeedCell: UICollectionViewCell {
    // MARK: - Properties
    var viewModel: PostViewModel? {
        didSet {
            configurePostViewModel()
        }
    }
    weak var delegate: FeedCellDelegate?
    var viewModelUser: UserCellViewModel?
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()

    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        return button
    }()

    private lazy var sharedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private var stackView = UIStackView()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionsButton()
        
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureActionsButton() {
        stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sharedButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
    
    func configurePostViewModel() {
        guard let viewModel = viewModel else { return }
        
        UserService.fetchUser(withUid: viewModel.ownerUid) { user in
            self.viewModelUser = UserCellViewModel(user: user)
            self.captionLabel.text = viewModel.caption
            self.postImageView.sd_setImage(with: viewModel.postImageView)
            self.likesLabel.text = viewModel.postLikeLabel
            guard let viewModelUser = self.viewModelUser else { return }
            self.usernameButton.setTitle(viewModelUser.username, for: .normal)
            self.profileImageView.sd_setImage(with: viewModelUser.profileImageView)
            self.likeButton.tintColor = viewModel.likeButtonTintColor
            self.likeButton.setImage(viewModel.likeButtonImage, for: .normal)
            self.postTimeLabel.text = viewModel.timestampString
        }
        
    }
    
    // MARK: - Actions
    @objc func showUserProfile() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowProfile: viewModel.post.ownerUid)
    }
    
    @objc func didTapLikeButton() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToLikePost: viewModel.post)
    }
    
    @objc func didTapCommentButton() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowCommentForPost: viewModel.post)
    }
    
    @objc func didTapShareButton() {
        print("Debug: didTapShareButton")
    }
}
