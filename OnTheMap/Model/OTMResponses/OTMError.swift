//
//  OTMErrorle.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/21/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

enum OTMError: String, Error {
    
    //POST Session / User Login specific errors
    case invalidCredentials = "We had a problem logging you in.\nPleasse check your login details and try again." //403 client error
    case incompleteLoginForm = "Please ensure both email and password fields are completed."
    
    
    //Student media URLS
    case badURL = "Cannot open mediaURL.\nURL does not contain required https scheme."
    

    //Global errors
    //network errors
    case unableToComplete = "Unable to complete request.\nPlease check internet connection."
    case invalidResponse = "Invalid response from server.\nPlease try again." //500 server error
    
    //bad data errors
    case invalidData = "Data received from server was invalid.\nPlease try again."
    
    
}
