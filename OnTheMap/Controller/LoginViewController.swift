//
//  ViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //properties
    var isKeyboardVisible = false
    
    //storyboard outlets
    @IBOutlet var loginStackViews: [UIStackView]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var loginFormTextFields: [UITextField]!
    
    
    //storyboard actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        fireCreateUserSession()
    }
    
    @IBAction func signUpLabelTapped(_ sender: Any) {
        print("Sign up label tapped")
    }
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //subscriobe to notifications
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func configureUI() {
        
        //set vc/self as delegate of text fields
        loginFormTextFields.forEach { $0.delegate = self }
    }
    
    
    func loggingUserIn(flag: Bool) {
        if flag {
            activityIndicator.startAnimating()
            loginStackViews.forEach { $0.isUserInteractionEnabled = false }
            
        } else {
            activityIndicator.stopAnimating()
            loginStackViews.forEach { $0.isUserInteractionEnabled = true }
        }
    }
    
    
    func fireCreateUserSession() {
        
        //ensure both emial or password fields have data
        guard loginFormTextFields[0].text != "" && loginFormTextFields[1].text != "" else {
            self.presentUserAlert(title: "Login Form Incomplete!", message: OTMError.incompleteLoginForm.rawValue)
            return
        }
        
        //start activity indicator animtion
        self.loggingUserIn(flag: true)
        
        //set username / password from text fields
        var username = String()
        var password = String()
        
        for textField in loginFormTextFields {
            
            if textField.tag == 0 {
                if let text = textField.text {
                    username = text
                }
            }
             if textField.tag == 1 {
                if let text = textField.text {
                    password = text
                }
            }
        }
        
        let credentials = UserCredentials(username: username, password: password)
        OTMNetworkController.createUserSession(using: credentials) { [weak self] (result) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loggingUserIn(flag: false)

                switch result {
                    
                //if login success, segue to next vc / screen
                case.success:
                    self.performSegue(withIdentifier: "LoginVCToTabBarController", sender: nil)
                    
                //if login error, present error alert with specific error reason to user
                case .failure(let error):
                    self.presentUserAlert(title: "Uh Oh!", message: error.rawValue)
                }
            }
        }
    }
}


//MARK: Notifications
extension LoginViewController: UINavigationControllerDelegate {
    
    //Keyboard notifications
    func subscribeToKeyboardNotifications() {
        
        //subscribe to KB specific notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardVisible else { return } //ensure kb isn't already visible before moving view
        
        view.frame.origin.y = -getKeyboardHeight(notification) / 3
        isKeyboardVisible = true
    }
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
        isKeyboardVisible = false
    }
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let kbSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return kbSize.cgRectValue.height
    }
    
    
}


//MARK:- UITextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         return textField.resignFirstResponder()
    }
}


