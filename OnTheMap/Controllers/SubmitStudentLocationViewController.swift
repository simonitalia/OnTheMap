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
    
    var mapItem: MKMapItem? {
        if let mapItem = mapItems.first {
            return mapItem
        } else {
            return nil
        }
    }
    
    
    //MARK:- Storyboard Connections
    //storyboard outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    //storyboard action outlest
    @IBAction func submitLocationButtonTapped(_ sender: Any) {
        submitStudentLocation()
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
        guard let mapItem = self.mapItem else { return }
        
        
        

        
        
        print("mapString object received: \(mapString ?? "no mapString")")
        print("mapItems object received: \(String(describing: mapItems))")
        print("mediaURL object received: \(mediaURL ?? "no mediaURL")")

//        openMaps(mapItems: [mapItem], launchOptions: nil)

    }
    
    
    private func submitStudentLocation() {
        guard let mapItem = self.mapItem else { return }
        
    
        //note! some values are hard-codes since getting user informationo via uniqueKey won't work since they are randomized values
//        let postObject = POSTStudentLocation(mapString: mapString, longitude: Double, latitude: Double)
        
        
        
        //on success
        //set location object
        //segue back to StudentLocationsMapVC
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: SegueIdentifier.segueToStudentLocationsMapVC, sender: nil)
        }
        
        
        
        
    }
    
    
    

}
