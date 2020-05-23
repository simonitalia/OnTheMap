//
//  OTMErrorle.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/21/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

enum OTMError: String, Error {
    
    //POST Session specific Error cases
    case invalidCredentials = "We had a problem logging you in.\nPleasse check your login details and try again." //403 client error
    
    //Global Error cases
    //network errors
    case invalidResponse = "Invalid response from server.\nPlease try again." //500 server error
    case unableToComplete = "Unable to complete request.\nPlease check internet connection."
   
    //bad data errors
    case invalidData = "Data received from server was invalid.\nPlease try again."
}
