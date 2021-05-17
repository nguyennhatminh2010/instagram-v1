//
//  RegisterController.swift
//  Instagram
//
//  Created by admin on 08/05/2021.
//

import UIKit

class RegistrationController: UIViewController {
    // MARK: - Properties
    weak var delegate: AuthenticationDelegate?
    private var profileImage: UIImage?
    private var viewModel = RegistrationViewModel()
    
    private let pushImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.setDimensions(height: 140, width: 140)
        button.addTarget(self, action: #selector(handlePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField = CustomTextField(placeholder: "Full name")
    
    private let usernameTextField = CustomTextField(placeholder: "Username")
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setHeight(50)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.67)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let haveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Log in")
        button.addTarget(self, action: #selector(showLoginScreen), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    // MARK: - Actions
    @objc func showLoginScreen() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField{
            viewModel.password = sender.text
        } else if sender == fullNameTextField{
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        updateForm()
    }
    
    @objc func handlePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credential = AuthCredential(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        AuthService.registerUser(withCredential: credential) { error in
            if let e = error {
                print("DEBUG: Something wrong while creating new user \(e.localizedDescription)")
                return
            }
            print("DEBUG: Successfully registered user with firestore...")
            self.delegate?.authenticationDidCompleted()
        }
    }
    // MARK: - Helpers
    func configureUI() {
        configureGradientLayout()
        
        view.addSubview(pushImageButton)
        pushImageButton.centerX(inView: view)
        pushImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,
                                                       fullNameTextField, usernameTextField,
                                                        signupButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.anchor(top: pushImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32 )
        
        view.addSubview(haveAccountButton)
        haveAccountButton.centerX(inView: view)
        haveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}

// MARK: - FormViewModel
extension RegistrationController: FormViewModel {
    func updateForm() {
        signupButton.backgroundColor = viewModel.buttonBackground
        signupButton.isEnabled = viewModel.formIsValid
        signupButton.tintColor = viewModel.buttonTintColor
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        pushImageButton.layer.cornerRadius = pushImageButton.frame.width / 2
        pushImageButton.layer.masksToBounds = true
        pushImageButton.layer.borderWidth = 2
        pushImageButton.layer.borderColor = UIColor.white.cgColor
        pushImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}
