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
    
    
    
    //MARK:- Class Properties
    //received from FindStudentLocationVC
    var mapString: String!
    var mediaURL: String!
    var mapItems: [MKMapItem]!
    
    
    //MARK:- Storyboard Connections
    //storyboard outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    //storyboard action outlest
    @IBAction func submitLocationButtonTapped(_ sender: Any) {
        
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
        print("mapString object received: \(mapString ?? "no mapString")")
        print("mapItems object received: \(String(describing: mapItems))")
        print("mediaURL object received: \(mediaURL ?? "no mediaURL")")
    }
    
    
    
    

}
