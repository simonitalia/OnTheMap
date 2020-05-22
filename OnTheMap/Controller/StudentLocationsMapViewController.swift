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
    
    //shared property for storing feteched student locations
    static var studentLocations = [StudentInformation]()
    private var itemsLimit = 100
    
    
    //storyboard outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureUI()
    }
    
    
    private func configureUI() {
        fireGetStudentLocations()
    }
    
    
    private func fireGetStudentLocations() {
        OTMNetworkController.getStudentLocations(with: itemsLimit, skipItems: StudentLocationsMapViewController.studentLocations.count) { (result) in

            switch result {
            case .success(let studentLocations):
                print("Success! StudentLocations fetched.")
                StudentLocationsMapViewController.studentLocations.append(contentsOf: studentLocations.locations)
                
                //create map annotations and set pins
                self.createMapAnnotations()
                
            case .failure(let error):
                print("Error! Could not fetch student locations: Reason: \(error.rawValue)")
            }
        }
    }
    
    
    private func createMapAnnotations() {
        guard !StudentLocationsMapViewController.studentLocations.isEmpty else { return }
        
        StudentLocationsMapViewController.studentLocations.forEach {
            let annotation = MKPointAnnotation()
            
            //set title and subtitle text
            annotation.title = createFullName(with: $0.firstName, and: $0.lastName)
            annotation.subtitle = $0.mediaURL
            
            //set coordinates
            let lat = Double($0.latitude)
            let long = Double($0.longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            //add annotation to MKMapView
            mapView.addAnnotation(annotation)
        }
    }
    
}

//MARK:- MKMAPView Delegate
extension StudentLocationsMapViewController: MKMapViewDelegate {
    
    //create a pinView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
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
