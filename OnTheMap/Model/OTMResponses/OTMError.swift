//
//  OTMErrorle.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/21/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation


//custom errors
enum OTMError: String, Error {
    
    //POST Session specific Error cases
    case invalidCredentials = "We had a problem logging you in.\nPleasse check your login details and try again." //403 client error
    
    //Global Error cases
    //network errors
    case invalidResponse = "Invalid response from server.\nPlease try again." //500 server error
    case unableToComplete = "Unable to complete request.\nPlease check internet connection."
   
    //bad data or decoding errors
    case unableToParseJSON = "Error parsing JSON data, please try again"
    case invalidData = "Data received from server was invalid.\nPlease try again."
}


//server error response data format
extension OTMError {
    struct OTMError: Codable, Error {
        let status: String
        let message: String
        
        enum CodingKeys: String, CodingKey {
            case status
            case message = "error"
        }
    }
}
