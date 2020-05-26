//
//  POSTStudentLocation.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/24/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

//model for POST and PUT Student Location
struct POSTStudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let longitude: Double
    let latitude: Double
    
    
    //has an init method to auto generate and set uniqueKey when intialized
    init(firstName: String, lastName: String, mapString: String, mediaURL: String, longitude: Double, latitude: Double) {
        self.uniqueKey = {
            return UUID().uuidString
        }()
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.longitude = longitude
        self.latitude = latitude
    }
}
