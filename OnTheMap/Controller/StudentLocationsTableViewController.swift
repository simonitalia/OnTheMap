//
//  StudentLocationsTableViewController.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/22/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: UITableViewController {
    
    //properties
    let resuseIdentifier = "StudentLocationCell"
    
    var studentLocations: [StudentInformation] {
        return StudentLocationsMapViewController.studentLocations
    }
    
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }



    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath)

        //configure cell
        let row = indexPath.row
        let name = studentLocations[row].firstName + " " + studentLocations[row].lastName
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = studentLocations[row].mediaURL
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInformation = studentLocations[indexPath.row]
        
        //open mediaURL in safari on row tap
        if let url = URL(string: studentInformation.mediaURL) {
            
            //open mediaURL
            if url.scheme == "https"  {
                self.presentSafariViewController(with: url)
             
            //guard against badly formatted medialURL
            } else {
                self.presentUserAlert(title: "Bad URL Scheme!", message: OTMError.badURL.rawValue)
            }
        }
    }
    
}
