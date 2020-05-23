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
    
    
    //get reference to shared app delegate object
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //set student locations data locally
    private var studentLocations: [StudentInformation] {
        return appDelegate.studentLocations
    }
    
    
    //storyboard outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    //Storboard action outlets
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.performUserLogOut()
    }
    
    
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    private func configureUI() {
        performSelector(inBackground: #selector(fireGetStudentLocations), with: nil)
    }
    
    
    @objc private func fireGetStudentLocations() {
        
        OTMNetworkController.shared.getStudentLocations(with: appDelegate.itemsLimit, skipItems: appDelegate.studentLocations.count) { (result) in
            
            switch result {
            case .success(let studentLocations):
                print("Success! StudentLocations fetched.")
                
                //save studentloactins to shared object
                self.appDelegate.studentLocations.append(contentsOf: studentLocations.locations)
                
                //create map annotations and set pins
                self.createMapAnnotations()
                
            case .failure(let error):
                self.presentUserAlert(title: "Student Locations Download Error!", message: error.rawValue)
            }
        }
    }
    
    
    private func createMapAnnotations() {
        guard !studentLocations.isEmpty else { return }
        
        studentLocations.forEach {
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
