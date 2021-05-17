//
//  ProfileItemCell.swift
//  Instagram
//
//  Created by admin on 09/05/2021.
//

import UIKit
import SDWebImage

class ProfileItemCell: UICollectionViewCell {
    // MARK: - Properties
    var viewModel: PostViewModel? {
        didSet {
            configurePostViewModel()
        }
    }
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    func configureUI() {
        backgroundColor = .white
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    func configurePostViewModel() {
        guard let viewModel = viewModel else { return }
        postImageView.sd_setImage(with: viewModel.postImageView)
    }
}
