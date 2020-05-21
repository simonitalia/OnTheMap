//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/21/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

extension UIViewController {
     
    func presentUserAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}
