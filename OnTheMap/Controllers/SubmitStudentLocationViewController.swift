//
//  SubmitStudentLocationViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/25/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit
import MapKit

class SubmitStudentLocationViewController: UIViewController {
    
    //MARK: Class Properties
    enum SegueIdentifier {
        static let segueToStudentLocationsMapVC = "UnwindToStudentLocationsMapVC"
    }
    
    //MARK:- Class Properties
    //received from FindStudentLocationVC
    var mapString: String!
    var mediaURL: String!
    var mapItems: [MKMapItem]!
    
    lazy var mapItem: MKMapItem! = {
        return mapItems.first
    }()
    
    //instantiate student location object
    lazy var studentLocation: POSTStudentLocation? = {
        let first = "Magical", last = "Tomato" //hardcode first and last
        let object = POSTStudentLocation(firstName: first, lastName: last, mapString: mapString, mediaURL: mediaURL, longitude: mapItem.placemark.coordinate.longitude, latitude: mapItem.placemark.coordinate.latitude)
        return object
    }()
    
    //MARK:- Storyboard Connections
    //storyboard outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    //storyboard action outlest
    @IBAction func submitLocationButtonTapped(_ sender: Any) {
//        submitStudentLocation()
    }
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUI()
    }
    
    
    //MARK: View Setup
    private func configureVC() {
        //set delegates
        mapView.delegate = self
    }
    
    
    private func configureUI() {
        createMapAnnotation()
    }
    
    
    private func createMapAnnotation() {
        guard let studentLocation = self.studentLocation else { return }
        
        let annotation = MKPointAnnotation()
        
        //set title and subtitle text
        annotation.title = mapString
        
        //set coordinates
        let lat = Double(studentLocation.latitude)
        let long = Double(studentLocation.longitude)
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        //add annotation to MKMapView
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation) //done on main thread so pins appear on view/map load
            self.mapView.centerCoordinate = annotation.coordinate //move map to coordinates
        }
    }
    
    

    private func submitStudentLocation() {
        guard let postObject = self.studentLocation else { return }
     
        //update existing student location objectID
        if let objectID = AppDelegate.studentLocation?.objectId {
            OTMNetworkController.shared.submitStudentLocation(as: .put, with: postObject, objectID: objectID) { (result) in
                
                switch result {
                case .success(let updatedAt):
                    print("Successs! Updated Student Location with new location.")
                    
                    //update student location createdAt with updatedAt response
//                    AppDelegate.studentLocation?.createdAt = updatedAt
                    
                    //perform segue back to StudentLocationsMapVC
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: SegueIdentifier.segueToStudentLocationsMapVC, sender: nil)
                    }
                    
                case .failure:
                    print("Error! Failed to update Student Location with new location.")
                    //present error alert
                    return
                }
    
            }
         
        //post new and create new student location object
        } else {
            OTMNetworkController.shared.submitStudentLocation(as: .post, with: postObject, objectID: nil) { (result) in
                        
                switch result {
                case .success(let studentLocation):
                    print("Successs! Created new Student Location.")
                    
                    //set student location property
                    AppDelegate.studentLocation = studentLocation
                    
                    //perform segue back to StudentLocationsMapVC
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: SegueIdentifier.segueToStudentLocationsMapVC, sender: nil)
                    }
                    
                case .failure:
                    print("Error! Failed to create new Student Location")
                    //present error alert
                    return
                }
            }
        }
    }
}
