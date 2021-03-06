//
//  OTMAlertMessage.swift
//  OnTheMap
//
//  Created by Simon Italia on 5/23/20.
//  Copyright © 2020 SDI Group Inc. All rights reserved.
//

import Foundation

enum OTMAlertMessage {
    static let incompleteForm = "Please ensure all form fields are completed."
    static let badURL = "Cannot open mediaURL.\nURL is not prefixed with a valid scheme (eg: https)."
    static let locationNotFound = "Sorry, we could not find that location.\n Please try another location."
    static let updateLocationConfirmation = "You have already submitted a location.\nAre you sure you want to update with this new location?"
}
