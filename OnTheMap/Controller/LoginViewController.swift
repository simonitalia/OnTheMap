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
        
    }
    
    @IBAction func signUpLabelTapped(_ sender: Any) {
        print("Sign up label tapped")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credentials = UserCredentials(username: "simonitalia@gmail.com", password: "lio4!kBX20o#Xh49")
        
        OTMNetworkController.createUserSession(using: credentials) { (completion, error) in
            if let _ = completion {
                //
            }
            
            if let _ = error {
                //
            }
        }
    }
    
    
    


}

