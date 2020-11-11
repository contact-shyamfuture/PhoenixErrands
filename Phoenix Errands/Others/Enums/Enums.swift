//
//  Enums.swift
//  LastingVideoMemories
//
//  Created by  Software Llp on 05/10/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import Foundation

enum ResponseStatus {
    case success
    case failure
    case unknown
}

public enum Model  {
    case iPodTouch5
    case iPodTouch6
    case iPhone4
    case iPhone4s
    case iPhone5
    case iPhone5c
    case iPhone5s
    case iPhone6
    case iPhone6P
    case iPhone6S
    case iPhone6SP
    case iPhone7
    case iPhone7P
    case iPhoneSE
    case iPhone8
    case iPhone8P
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPad2
    case iPad3
    case iPad4
    case iPadAir
    case iPadAir2
    case iPad5
    case iPad6
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadPro97
    case iPadPro129
    case iPadPro1292
    case iPadPro105
    case AppleTV
    case AppleTV4K
    case HomePod
    case Simulator
    case unknown
    
    public var description: String {
        switch self {
        case .iPodTouch5:
            return "iPod Touch 5"
        case .iPodTouch6:
            return "iPod Touch 6"
        case .iPhone4:
            return "iPhone 4"
        case .iPhone4s:
            return "iPhone 4s"
        case .iPhone5:
            return "iPhone 5"
        case .iPhone5c:
            return "iPhone 5c"
        case .iPhone5s:
            return "iPhone 5s"
        case .iPhone6:
            return "iPhone 6"
        case .iPhone6P:
            return "iPhone 6 Plus"
        case .iPhone6S:
            return "iPhone 6S"
        case .iPhone6SP:
            return "iPhone 6S Plus"
        case .iPhone7:
            return "iPhone 7"
        case .iPhone7P:
            return "iPhone 7 Plus"
        case .iPhoneSE:
            return "iPhone SE"
        case .iPhone8:
            return "iPhone 8"
        case .iPhone8P:
            return "iPhone 8 Plus"
        case .iPhoneX:
            return "iPhone X"
        case .iPhoneXS:
            return "iPhone XS"
        case .iPhoneXSMax:
            return "iPhone XS Max"
        case .iPhoneXR:
            return "iPhone XR"
        case .iPad2:
            return "iPad 2"
        case .iPad3:
            return "iPad 3"
        case .iPad4:
            return "iPad 4"
        case .iPadAir:
            return "iPad Air"
        case .iPadAir2:
            return "iPad Air 2"
        case .iPad5:
            return "iPad 5"
        case .iPad6:
            return "iPad 6"
        case .iPadMini:
            return "iPad Mini"
        case .iPadMini2:
            return "iPad Mini 2"
        case .iPadMini3:
            return "iPad Mini 3"
        case .iPadMini4:
            return "iPad Mini 4"
        case .iPadPro97:
            return "iPad Pro 9.7"
        case .iPadPro129:
            return "iPad Pro 12.9"
        case .iPadPro1292:
            return "iPad Pro 12.9 2 Generation"
        case .iPadPro105:
            return "iPad Pro 10.5"
        case .AppleTV:
            return "Apple TV"
        case .AppleTV4K:
            return "Apple TV 4K"
        case .HomePod:
            return "Home Pod"
        case .Simulator:
            return "Simulator"
        case .unknown:
            return "Unknown Device"
        }
    }
}


public enum MemoryCreationStatus {
    case notCreated //memory not created or memory creation completed
    case scheduleNotAdded // memory created but schedulr not added
    case topicNotAdded // schedule added but topic not added
    case topicNotAddedForAllSchedules // topic not added for all schedules
    case topicAddedVideoNotUploaded // topic added but video not uploaded
    case videoUploadedButNotCompleted // video uploaded but memory creation not completed
    
    public var statusValue: Int {
        switch self {
        case .notCreated:
            return 0
        case .scheduleNotAdded:
            return 1
        case .topicNotAdded:
            return 2
        case .topicNotAddedForAllSchedules:
            return 3
        case .topicAddedVideoNotUploaded:
            return 4
        case .videoUploadedButNotCompleted:
            return 5
        }
    }
}
