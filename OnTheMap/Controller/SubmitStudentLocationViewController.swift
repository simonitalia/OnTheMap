//
//  MasterViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/24/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

class SubmitStudentLocationViewController: UIViewController {
    
    //storyboard outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!


    //storyboard action outlets
    @IBAction func findLocationButtonTapped(_ sender: Any) {
       performFindLocation()
    }
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
    
    
    //MARK:- View
    private func configureView() {
        locationTextField.delegate = self
        urlTextField.delegate = self
    }
    
    
    private func performFindLocation() {
        
        //ensure both fields are filled in first
        guard locationTextField.hasText && urlTextField.hasText else {
            self.presentUserAlert(title: "Form Incomplete!", message: OTMAlertMessage.incompleteForm)
            return
        }
        
    }
    
}
