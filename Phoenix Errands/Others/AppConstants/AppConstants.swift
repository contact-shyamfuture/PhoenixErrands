//
//  AppConstants.swift
//  DealerApp
//
//  Created by Shyam Future Tech on 28/01/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = () -> ()
typealias RequestCompletionHandler = (Response) -> ()
typealias NetworkObserverCompletionHandler = (Network.Status) -> ()

let hostNameForRechabilityCheck = "www.google.com"

let token = AppPreferenceService.getString(PreferencesKeys.userToken)
let HeaderDic = ["Authorization": "Token " + AppPreferenceService.getString(PreferencesKeys.userToken)!,"Content-Type": "application/x-www-form-urlencoded"]

let IS_LOGGED_IN: Int = 1
let IS_LOGGED_OUT: Int = 0

struct Constants {
    
     struct App {
        
        static let navigationBarColor: UIColor = UIColor(rgb: 0xEEF3F7)
        static let statusBarColor: UIColor = UIColor(rgb: 0xEEF3F7)
    }
}
//
public struct PreferencesKeys {
    static let loggedInStatus = "loggedInStatus"
    static let userName = "userName"
    static let userEmail = "userEmail"
    static let userImage = "userImage"
    static let userToken = "userToken"
    static let userPassword = "userPassword"
    static let userID = "userID"
    static let rememberMe = "rememberMe"
    static let priceTag = "priceTag"
    static let priceIDs = "priceIDs"
    static let stateID = "stateID"
    static let FCMTokenDeviceID = "FCMTokenDeviceID"
    static let notificationCount = "notificationCount"
    
    static let userFirstName = "userFirstName"
    static let userLastName = "userLastName"
    
    static let memoryCreationStatus = "memoryCreationStatus"
    static let memoryID = "memoryID"
    
    // Last created memory Details
    static let memoryTitle = "memoryTitle"
    static let memoryPrimaryEmail = "memoryPrimaryEmail"
    static let memorySecondaryEmail = "memorySecondaryEmail"
    static let memoryPrimaryMobile = "memoryPrimaryMobile"
    static let memorySecondaryMobile = "memorySecondaryMobile"
    static let currentLat = "currentLat"
    static let currentLong = "currentLong"
}
