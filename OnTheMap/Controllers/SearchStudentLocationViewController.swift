//
//  MasterViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/24/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit
import MapKit

class SearchStudentLocationViewController: UIViewController {
    
    //MARK:- Class Properties
    private enum SegueIdentifier {
        static let segueToSubmitStudentLocationVC = "FindLocationVCToSubmitLocationVC"
    }
    
    
    //location searche results
    var mapLocationSearchResults: [MKMapItem]!
    
    
    //MARK:- Storyboard Connections
    //storyboard outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var findLocationStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    //storyboard action outlets
    @IBAction func findLocationButtonTapped(_ sender: Any) {
       performFindLocation()
    }
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //subscriobe to notifications
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK:- View Setup
    private func configureVC() {
        //set delegates
        locationTextField.delegate = self
        urlTextField.delegate = self
    }
    
    
    func configureUI() {
        #if targetEnvironment(simulator)
        urlTextField.text = "https://magicaltomato.com"
        #endif
    }
    
    
    //MARK:- Location Management
    //find location
    private func performFindLocation() {
        
        //ensure both fields are filled in first
        guard locationTextField.hasText && urlTextField.hasText else {
            self.presentUserAlert(title: "Form Incomplete!", message: OTMAlertMessage.incompleteForm)
            return
        }
        
        //start activity view and disable view interaction
        performingLocationSearch(true)
        
        //perform search for location entered
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationTextField.text
        let search = MKLocalSearch(request: searchRequest)
        
        //trigger search and handle response
        search.start { [weak self] (response, error) in
            guard let self = self else { return }
            
            //stop activity view and enbale view interaction
            self.performingLocationSearch(false)
            
            //if location search failed, trigger alert
            guard let response = response else {
                self.presentUserAlert(title: "Location Not Found", message: OTMAlertMessage.locationNotFound)
                print("Error: \(error?.localizedDescription ?? "Unknown error").")// for debugging
                return
            }

            //if location succeeds, set results to local properties
            print("Success! Location/s found: \(response.mapItems).")
            self.mapLocationSearchResults = response.mapItems
            
            //tirgger segue
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SegueIdentifier.segueToSubmitStudentLocationVC, sender: self)
            }
        }
    }
    
    
    private func performingLocationSearch(_ flag: Bool) {
        
        //update view state and animate
        updateViewState(for: [findLocationStackView], to: flag, animate: activityIndicator)
    }
    
    
    //MARK: Navigation Setup
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapString = self.locationTextField.text, let mediaURL = urlTextField.text, let mapItems = mapLocationSearchResults else { return }
        
        if segue.identifier == SegueIdentifier.segueToSubmitStudentLocationVC {
            let vc = segue.destination as! SubmitStudentLocationViewController
            vc.mapString = mapString
            vc.mediaURL = mediaURL
            vc.mapItems = mapItems
        }
    }
}
