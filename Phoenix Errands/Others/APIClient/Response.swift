//
//  Response.swift
//  LastingVideoMemories
//
//  Created by   on 05/10/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import Foundation

class Response: NSObject {
    
    var responseStatus: ResponseStatus = .unknown
    var responseStatusCode: Int?
    var message:String?
    var data:AnyObject?
    
    convenience init(code: ResponseStatus, responseStatusCode: Int, message: String, data: AnyObject?) {
        self.init()
        self.responseStatus = code
        self.responseStatusCode = responseStatusCode
        self.message = message
        self.data = data
    }
}
