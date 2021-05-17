//
//  File.swift
//  Instagram
//
//  Created by admin on 15/05/2021.
//

import UIKit
import SDWebImage

class CommentCell: UICollectionViewCell {
    // MARK: - Properties
    var viewModel: CommentViewModel? {
        didSet {
            configureCommentViewModel()
        }
    }
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let commentLabel = UILabel()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        addSubview(commentLabel)
        commentLabel.numberOfLines = 0
        commentLabel.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    func configureCommentViewModel() {
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = viewModel.configureCommentLabel()
    }
}
