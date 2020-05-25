//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/22/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

struct StudentLocations: Codable {
    let locations: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case locations = "results"
    }
}
