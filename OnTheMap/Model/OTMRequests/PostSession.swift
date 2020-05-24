//
//  PostSession.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

struct POSTSession: Codable {
    let credentials: UserCredentials
    
    enum CodingKeys: String, CodingKey {
        case credentials = "udacity"
    }
}

struct UserCredentials: Codable {
    let username: String
    let password: String
}


