//
//  ViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

//properties
enum SegueIdentifier {
    static let segueToTabBarController = "LoginVCToTabBarController"
    static let segueToLoginVC = "unwindToLoginVC"
}

class LoginViewController: UIViewController {
    
    private let udacityWebSignin = "https://auth.udacity.com/sign-in"
    
    
    //storyboard outlets
    @IBOutlet var loginStackViews: [UIStackView]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var loginFormTextFields: [UITextField]!
    
    
    //storyboard actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        performUserLogin()
    }
    
    
    @IBAction func signUpLabelTapped(_ sender: Any) {
        guard let url = URL(string: udacityWebSignin) else { return }
        presentSafariViewController(with: url)
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
    
    
    private func configureUI() {
        
        //set vc/self as delegate of text fields
        loginFormTextFields.forEach { $0.delegate = self }
        
        #if targetEnvironment(simulator)
        for textField in loginFormTextFields {
            if textField.tag == 0 {
                textField.text = "simonitalia@gmail.com"
            } else {
                textField.text = "lio4!kBX20o#Xh49"
            }
        }
        #endif
    }
    
    
    private func loggingUserIn(_ flag: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if flag {
                self.activityIndicator.startAnimating()
                self.loginStackViews.forEach { $0.isUserInteractionEnabled = false }
                
            } else {
                self.activityIndicator.stopAnimating()
                self.loginStackViews.forEach { $0.isUserInteractionEnabled = true }
            }
        }
    }
    
    
    private func performUserLogin() {
        
        //ensure both email and password fields have data
        guard loginFormTextFields.count == 2 else {
            print("Something went wrong! There should be 2 loginFormTextField objects.")
            return
        }
        
        guard loginFormTextFields[0].hasText && loginFormTextFields[1].hasText else {
            self.presentUserAlert(title: "Form Incomplete!", message: OTMAlertMessage.incompleteForm)
            return
        }
        
        //start activity indicator animation
        loggingUserIn(true)
        
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
        OTMNetworkController.shared.getUserSession(using: credentials) { [weak self] (result) in
            guard let self = self else { return }
                
            //stop activity indicator animation
            self.loggingUserIn(false)

            switch result {
                
            //if login success, segue to next vc / screen
            case.success(let sessionResponse):
                print("Success! UserSession created with session ID: \(sessionResponse.session.id)")
                
                //set shared userSession property and perform segue
                AppDelegate.userSession = sessionResponse
                self.performSegue(with: SegueIdentifier.segueToTabBarController)
                
            //if login error, present error alert with specific error reason to user
            case .failure(let error):
                self.presentUserAlert(title: "Uh Oh!", message: error.rawValue)
            }
        }
    }
    
    
    //log out navigation
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
        //returns user to this VC upon logout from any VC
        
        //reset shared data objects
        if segue.identifier == SegueIdentifier.segueToLoginVC {
            AppDelegate.userSession = nil //set session object to nil
            AppDelegate.studentLocations.removeAll() //remove all fetched studentLocations
        }
    }
}





