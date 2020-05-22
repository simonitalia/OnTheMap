//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Float
    let latitude: Float
    let mapString: String
    let mediaURL: String
    var uniqueKey: String?
    let objectId: String
    let createdAt: String
    let updatedAt: String
}




