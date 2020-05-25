//
//  POSTStudentLocation.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/24/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

//dummy data set as default
struct POSTStudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let longitude: Double
    let latitude: Double
    
    
    //has an init method to auto generate and set uniqueKey when intialized
    init(mapString: String, longitude: Double, latitude: Double) {
        self.uniqueKey = {
            return UUID().uuidString
        }()
        self.firstName = "Simon"
        self.lastName = "Italia"
        self.mapString = mapString
        self.mediaURL = "https://magicaltomato.com"
        self.longitude = longitude
        self.latitude = latitude
    }
}
