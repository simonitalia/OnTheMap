//
//  POSTStudentLocation.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/24/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

//dummy data set as default
struct POSTStudentLocation {
    let uniqueKey = {
        return UUID().uuidString
    }
    
    let firstName = "S"
    let lastName = "Italia"
    let mapString: String
    let mediaURL = "https://magicaltomato.com"
    let longitude: Double
    let latitude: Double
}
