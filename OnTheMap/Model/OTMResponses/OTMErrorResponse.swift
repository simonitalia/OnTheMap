//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

struct OTMErrorResponse: Codable, Error {
    let status: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "error"
    }
    
    var errorMessage: String {
        return message
    }
}


