//
//  ViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //storyboard outlets
    @IBOutlet var loginFormTextFields: [UITextField]!
    
    
    //storyboard actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        fireCreateUserSession()
    }
    
    @IBAction func signUpLabelTapped(_ sender: Any) {
        print("Sign up label tapped")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func fireCreateUserSession() {
        
        //ensure both emial or password fields have data
        guard loginFormTextFields[0].text != "" && loginFormTextFields[1].text != "" else {
            self.presentUserAlert(title: "Login Form Incomplete!", message: OTMError.incompleteLoginForm.rawValue)
            return
        }
        
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
            
            switch result {
                
            //if login success, segue to next vc / screen
            case.success:
                print("Session created")
                //perform segue
                
            //if login error, present error alert with specific error reason to user
            case .failure(let error):
                self.presentUserAlert(title: "Uh Oh!", message: error.rawValue)
            }
        }
    }
}



