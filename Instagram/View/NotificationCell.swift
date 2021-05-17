//
//  NotificationCell.swift
//  Instagram
//
//  Created by admin on 16/05/2021.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate: class {
    func cell(_ cell: NotificationCell, wantsToFlowUser uid: String)
    func cell(_ cell: NotificationCell, wantsToUnflowUser uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String)
}
class NotificationCell: UITableViewCell {
    // MARK: - Properties
    var viewModel: NotificationViewModel? {
        didSet {
            configureNotificationViewModel()
        }
    }
    weak var delegate: NotificationCellDelegate?
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "logoInstagram")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
      
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(height: 32, width: 88)
        followButton.anchor(right: rightAnchor, paddingRight: 12)
        
        contentView.addSubview(usernameLabel)
        usernameLabel.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        usernameLabel.anchor(right: followButton.rightAnchor, paddingRight: 8)

        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureNotificationViewModel() {
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        usernameLabel.attributedText = viewModel.notificationMessage
        followButton.isHidden = viewModel.shouldHidenFollowButton
        postImageView.isHidden = !viewModel.shouldHidenFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackground
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal) 
    }
    // MARK: - Actions
    @objc func handlePostTapped() {
        guard let postId = viewModel?.notification.postId else { return }
        delegate?.cell(self, wantsToViewPost: postId)
    }
    
    @objc func handleFollowTapped() {
        guard let uid = viewModel?.notification.uid else { return }
        guard let isFollowed = viewModel?.notification.userIsFollowed else { return }
        
        if isFollowed {
            delegate?.cell(self, wantsToUnflowUser: uid)
        } else {
            delegate?.cell(self, wantsToFlowUser: uid)
        }
    }
}
