//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/21/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
     
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
    
    
    func createFullName(with firstName: String, and lastName: String) -> String {
        return "\(firstName) \(lastName)"
    }
    
    
    func performUserLogOut() {
        OTMNetworkController.shared.deleteUserSession() { (result) in
            
            switch result {
            case .success(let deleteSession):
                //seugue back to login screen
                print("Success! Deleted sessionID: \(deleteSession.session.id)")
                
            case .failure(let error):
                //present error alart
                print("Error! Failed to log user out. Reason: \(error.rawValue)")
            }
        }
    }
}
