//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/21/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit
import SafariServices
import MapKit


extension UIViewController {
    
    func createFullName(with firstName: String, and lastName: String) -> String {
        return "\(firstName) \(lastName)"
    }
     
    
    //MARK:- View Controller Presentation
    func presentUserAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    
    func presentSafariViewController(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    
    //MARK: Update View/s State
    func updateViewState(for views: [UIView], to flag: Bool, animate activityIndicator: UIActivityIndicatorView) {
        
        DispatchQueue.main.async {
            if flag {
                activityIndicator.startAnimating()
                views.forEach { $0.isUserInteractionEnabled = !flag }
                
            } else {
                activityIndicator.stopAnimating()
                views.forEach { $0.isUserInteractionEnabled = !flag }
            }
        }
    }
    
    
    //MARK:- Network Requets
    @objc func performGetStudentLocations(completion: @escaping () -> Void) {

        OTMNetworkController.shared.getStudentLocations(with: AppDelegate.itemsLimit, skipItems: AppDelegate.studentLocations.count) { (result) in

            switch result {
            case .success(let studentLocations):
                print("Success! StudentLocations fetched.")

                //save studentloactins to shared object
                AppDelegate.studentLocations.append(contentsOf: studentLocations.locations)
                completion()
                
            case .failure(let error):
                self.presentUserAlert(title: "Student Locations Download Error!", message: error.rawValue)
            }
        }
    }
    
    
    func performUserLogOut() {
        OTMNetworkController.shared.deleteUserSession() { (result) in
            
            switch result {
            case .success(let deleteSession):
                print("Success! Deleted sessionID: \(deleteSession.session.id)")
                
                //seugue back to login screen
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueIdentifier.segueToLoginVC, sender: nil)
                }
                
            case .failure(let error):
                //present error alart
                print("Error! Failed to log user out. Reason: \(error.rawValue)")
            }
        }
    }
    
    
    //MARK:- Keyboard Observer
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification) / 3
    }
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let kbSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return kbSize.cgRectValue.height
    }
}


//MARK: Notifications
extension UIViewController {
    
    //Keyboard notifications
    func subscribeToKeyboardNotifications() {
        
        //subscribe to KB specific notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


//MARK:- UITextField Delegate
extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         return textField.resignFirstResponder()
    }
}


//MARK:- MKMAPView Delegate
extension UIViewController: MKMapViewDelegate {
    
    //create a pinView
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
