//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/20/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

struct SessionResponse: Codable, Hashable {
    let account: Account
    let session: Session
}


struct Account: Codable, Hashable {
    let registered: Bool
    let key: String
}


struct Session: Codable, Hashable {
    let id: String
    let expiration: String
}
