//
//  CommonResponseModel.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 05/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class CommonResponseModel: Mappable {
    
    var status : Int?
    var isServiceFound : Bool?
    var message : String?
    var erroString : [String]?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        isServiceFound <- map["isServiceFound"]
        message <- map["message"]
        erroString <- map["error.serviceid"]
    }
}
