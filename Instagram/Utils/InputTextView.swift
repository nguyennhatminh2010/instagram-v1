//
//  InputTextView.swift
//  Instagram
//
//  Created by admin on 13/05/2021.
//

import UIKit

class InputTextView: UITextView {
    //MARK: - Properties
    var placehoderText: String? {
        didSet {
            placehoderLabel.text = placehoderText
        }
    }
    let placehoderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placehoderShouldCenter = true {
        didSet {
            if placehoderShouldCenter {
                placehoderLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 8)
                placehoderLabel.centerY(inView: self)
            } else {
                placehoderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 8)
            }
        }
    }
    //MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
                
        addSubview(placehoderLabel)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handelTextDidChanged),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    @objc func handelTextDidChanged() {
        placehoderLabel.isHidden =  !text.isEmpty
    }
}
