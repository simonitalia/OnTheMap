//
//  StudentLocationsMapViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/22/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationsMapViewController: UIViewController {
    
    //MARK:- Class Properties
    enum SegueIdentifier {
        static let segueToSearchStudentLocationVC = "LocationsMapVCToSearchLocationVC"
    }
    
    
    //MARK:- Storyboard Connections
    //storyboard outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    //Storboard action outlets
    @IBAction func refreshStudentLocationsButtonTapped(_ sender: Any) {
        configureUI()
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        performUserLogOut()
    }
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUI()
    }

    
    //MARK:- View Setup
    private func configureVC() {
        //set delegates
        mapView.delegate = self
    }
    
    
    private func configureUI() {
        
        //fetch student locations data, create map annotations and set pins
        performGetStudentLocations {
            self.createMapAnnotations()
        }
    }
    
    
    //MARK:- Map Annotations
    private func createMapAnnotations() {
        guard !AppDelegate.studentLocations.isEmpty else { return }
        
        AppDelegate.studentLocations.forEach {
            let annotation = MKPointAnnotation()
            
            //set title and subtitle text
            annotation.title = createFullName(with: $0.firstName, and: $0.lastName)
            annotation.subtitle = $0.mediaURL
            
            //set coordinates
            let lat = Double($0.latitude)
            let long = Double($0.longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            //add annotation to MKMapView
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation) //done on main thread so pins appear on view/map load
            }
        }
    }
}


//MARK:- MKMAPView Delegate
extension StudentLocationsMapViewController {
    
    //open mediaURL when pinView annotaion is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let subtitle = view.annotation?.subtitle! else { return }
        
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: subtitle) {
                
                //open mediaURL
                if url.scheme == "https" || url.scheme == "http" {
                    self.presentSafariViewController(with: url)
                 
                //guard against badly formatted medialURL
                } else {
                    self.presentUserAlert(title: "Bad URL Scheme!", message: OTMAlertMessage.badURL)
                }
            }
        }
    }
}
