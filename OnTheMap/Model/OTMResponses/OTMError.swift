//
//  OTMErrorle.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/21/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

enum OTMError: String, Error {
    
    //login errors
    case invalidCredentials = "We had a problem logging you in.\nPleasse check your login details and try again." //403 client error
    case incompleteLoginForm = "Please ensure both email and password fields are completed."
    
    //bad data errors
    case invalidData = "Data received from server was invalid.\nPlease try again."
    
    //network errors
    case unableToComplete = "Unable to complete request.\nPlease check internet connection."
    case invalidResposne = "Invalid response from server.\nPlease try again." //500 server error
}
