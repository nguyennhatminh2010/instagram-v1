//
//  UploadPost.swift
//  Instagram
//
//  Created by admin on 13/05/2021.
//

import UIKit
protocol UploadPostDelegate: class {
    func didFinishUploadingPost(_ controller: UploadPostController)
}
class UploadPostController: UIViewController {
    // MARK: - Properties
    weak var delegate: UploadPostDelegate?
    var selectedImage: UIImage? {
        didSet {
            postImageView.image = selectedImage
        }
    }
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placehoderText = "Enter caption..."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        tv.placehoderShouldCenter = false
        return tv
    }()
    
    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Actions
    @objc func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapShareButton() {
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        showLoader(true)
        PostService.uploadPost(caption: caption, image: image) { error in
            self.showLoader(false)
            if let e = error {
                print("DEBUG: Fail to upload image with error \(e.localizedDescription)")
                return
            }
        }
        self.delegate?.didFinishUploadingPost(self)
    }
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapShareButton))
        
        view.addSubview(postImageView)
        postImageView.centerX(inView: view)
        postImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        postImageView.layer.cornerRadius = 10
        postImageView.setDimensions(height: 180, width: 180)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: postImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 6, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(textCountLabel)
        textCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingRight: 12)
    }
    
    func checkMaxLength(_ textView: UITextView) {
        if textView.text.count > 100 {
            textView.deleteBackward()
        }
    }
}

// MARK: -
extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        textCountLabel.text = "\(textView.text.count)/100"
    }
}
