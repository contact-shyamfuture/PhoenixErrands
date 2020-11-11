//
//  BidModel.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 10/09/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//


import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class BidModel: Mappable {
    
    var status  : Int?
    var total   : Int?
    var message : String?
    var perPage : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        total <- map["total"]
        perPage <- map["perPage"]
    }
}
class CompletedModel: Mappable {
    
    
    var status  : Int?
    var isSuccess  : Bool?
    var message : String?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        message <- map["message"]
    }
}


