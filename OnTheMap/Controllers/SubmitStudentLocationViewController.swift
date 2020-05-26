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
    
    lazy private var mapItem: MKMapItem! = {
        return mapItems.first
    }()
    
    //instantiate student location object
    lazy private var studentLocation: POSTStudentLocation? = {
        let first = "Udacity", last = "Student" //hardcode first and last
        let object = POSTStudentLocation(firstName: first, lastName: last, mapString: mapString, mediaURL: mediaURL, longitude: mapItem.placemark.coordinate.longitude, latitude: mapItem.placemark.coordinate.latitude)
        return object
    }()
    
    
    //location objectID
    private var objectID: String? {
        return AppDelegate.studentLocation?.studentLocation.objectId
    }
    
    
    //MARK:- Storyboard Connections
    //storyboard outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitLocationButton: UIButton!
    
    
    
    
    //storyboard action outlest
    @IBAction func submitLocationButtonTapped(_ sender: Any) {
        
        //trigger submit location
        //if student update exists, present confirmaton alert
        if let _ = objectID {
            presentUpdateLocationConfirmationAlert()
        
        //process student update
        } else {
           submitStudentLocation(httpMethod: OTMNetworkController.httpMethod.post)
        }
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
    
    
    //update location confirmation alert
    private func presentUpdateLocationConfirmationAlert() {
        let ac = UIAlertController(title: "Confirm Location Update!", message: OTMAlertMessage.updateLocationConfirmation, preferredStyle: .alert)
            
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in self.submitStudentLocation(httpMethod: OTMNetworkController.httpMethod.put)
        }))
        
        present(ac, animated: true)
    }
    
    
    private func submittingStudentLocation(_ flag: Bool) {
        
        //update view state and animate
        updateViewState(for: [mapView, submitLocationButton], to: flag, animate: activityIndicator)
    }
    
    
    private func submitStudentLocation(httpMethod: OTMNetworkController.httpMethod) {
        guard let postObject = self.studentLocation else { return }
        
        //start activity view and disable view interaction
        submittingStudentLocation(true)
        
        //post new and create new student location object
        switch httpMethod {
        case .post:
            OTMNetworkController.shared.postStudentLocation(with: postObject) { [weak self] (result) in
                guard let self = self else {return}
                
                //stop activity view and renable view interaction
                self.submittingStudentLocation(false)
                        
                switch result {
                case .success(let studentLocation):
                    
                    //set student location property
                    AppDelegate.studentLocation = (studentLocation: studentLocation, updatedAt: studentLocation.createdAt)
                    print("Successs! Created new Student Location object: \(String(describing: AppDelegate.studentLocation))")
                    
                    //perform segue back to StudentLocationsMapVC
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: SegueIdentifier.segueToStudentLocationsMapVC, sender: nil)
                    }
                    
                case .failure(let error):
                    
                    //present error alert
                    self.presentUserAlert(title: "Failed to Submit Location!", message: error.rawValue)
                    return
                }
            }
        
        //update existing student location objectID
        case .put:
            guard let objectID = objectID else { return }
            
            OTMNetworkController.shared.putStudentLocation(with: postObject, objectID: objectID) { (result) in
                
                switch result {
                case .success(let studentLocationUpdate):
                    
                    //update student location with updatedAt
                    AppDelegate.studentLocation?.updatedAt = studentLocationUpdate.updatedAt
                    print("Successs! Updated Student Location object: \(String(describing: AppDelegate.studentLocation))")
                    
                    //perform segue back to StudentLocationsMapVC
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: SegueIdentifier.segueToStudentLocationsMapVC, sender: nil)
                    }
                    
                case .failure(let error):
                    
                    //present error alert
                    self.presentUserAlert(title: "Failed to Update Location!", message: error.rawValue)
                    return
                }
            }
            
        default:
            print("Error! Canno submit student location, unknown case")
            break
        }
    }
}
