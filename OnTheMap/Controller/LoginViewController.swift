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
        
        var username = String()
        var password = String()
        
        for textField in loginFormTextFields {
            
            switch textField.tag {
            case 0:
                if let text = textField.text {
                    username = text
                }
            
            case 1:
                if let text = textField.text {
                    password = text
                }
                
            default:
                break
            }
        }
        
        let credentials = UserCredentials(username: username, password: password)
        
        OTMNetworkController.createUserSession(using: credentials) { (completion, error) in
            if let _ = completion {
                // segue to next screen
            }
            
            if let _ = error {
                //present error alert to user
                self.presentUserAlert(title: "Uh Oh!", message: "We had trouble logging you in.\nPlease check your username and pasword is correct and try again.")
            }
        }
    }
}



