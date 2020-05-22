//
//  StudentLocationsMapViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/22/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

class StudentLocationsMapViewController: UIViewController {
    
    //shared property for storing feteched student locations
    static var studentLocations = [StudentInformation]()
    var itemsLimit = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fireGetStudentLocations()
    }
    
    
    private func fireGetStudentLocations() {
        OTMNetworkController.getStudentLocations(with: itemsLimit, skipItems: StudentLocationsMapViewController.studentLocations.count) { (result) in

            switch result {
            case .success(let studentLocations):
                print("Success! StudentLocations fetched.")
                StudentLocationsMapViewController.studentLocations.append(contentsOf: studentLocations.locations)
                
                
            case .failure(let error):
                print("Error! Could not fetch student locations: Reason: \(error.rawValue)")
            }
        }
    }
}
