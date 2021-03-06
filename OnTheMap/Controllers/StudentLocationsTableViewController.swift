//
//  StudentLocationsTableViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/22/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: UITableViewController {
    

    //MARK:- Class Properties
    enum SegueIdentifier {
        static let segueToSearchStudentLocationVC = "LocationsTableVCToSearchLocationVC"
    }
    
    private let studentLocationCell = "StudentLocationCell"
    
    
    //MARK:- Storyboard Connections
    //storyboard action outlets
    @IBAction func refreshStudentLocationsButtonTapped(_ sender: Any) {
        performGetStudentLocations {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        performUserLogOut()
    }
    
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //no need to fetch student data on viewDidLoad since data laready fetched by StudentLocationsMapViewController
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    

    //MARK:- TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.studentLocations.count
    }

    
    //MARK:- TableView Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: studentLocationCell, for: indexPath)

        //configure cell
        let row = indexPath.row
        let name = createFullName(with: AppDelegate.studentLocations[row].firstName, and: AppDelegate.studentLocations[row].lastName)
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = AppDelegate.studentLocations[row].mediaURL
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInformation = AppDelegate.studentLocations[indexPath.row]
        
        //open mediaURL in safari on row tap
        if let url = URL(string: studentInformation.mediaURL) {
            
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
