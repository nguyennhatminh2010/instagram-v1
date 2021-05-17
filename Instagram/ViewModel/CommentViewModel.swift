//
//  CommentViewModel.swift
//  Instagram
//
//  Created by admin on 16/05/2021.
//

import UIKit

struct CommentViewModel {
    var comment: Comment
    var profileImageUrl: URL? {
        return URL(string: comment.profileImageUrl)
    }

    init(comment: Comment) {
        self.comment = comment
    }
    func configureCommentLabel() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: "\(comment.username)  ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributeString.append(NSAttributedString(string: comment.commentText, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        return attributeString
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.text = comment.commentText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
